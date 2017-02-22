#include <WiFi101.h>
#include <PubSubClient.h>

/* This code can handle either digital reads from
 * switches on analog reads from sensors (like photoresistors)
 * and this controls which "mode" it is in */
#define ANALOG_MODE 0
#define DIGITAL_MODE 1
#define READMODE ANALOG_MODE

/* How many locks do we have? */
#define LOCKCOUNT 1

/* This is the state of the switch when
 * the lock is considered "closed".
 * 1 means the switch is closed and the lock is closed
 * 0 means the swich is open and the lock is closed
 */
#define LOCK_CLOSED LOW /* digital */
float thresholds[LOCKCOUNT] = {350.0}; /* analog */

/* Values for tracking lock state */
#define CLOSED_STATE 0
#define OPEN_STATE   1

/* Analog storage for averaging */
int first_sample = 1;
float smooth_factor = 50; /* Sample weight factor */
float running_avg[LOCKCOUNT] = {0.0};

/* State tracking */
int previous_state[LOCKCOUNT] = {CLOSED_STATE};
int streak[LOCKCOUNT] = {0};
int alerted[LOCKCOUNT] = {0};

/* Status LED */
#define LED_ON  HIGH
#define LED_OFF LOW
int status_led = 6;

char state_name[2][256] = {"closed", "open"};
int state_led[2] = {LED_OFF, LED_ON};

/* String resources */
char game_name[] = "ctf";
char diff_name[LOCKCOUNT][256] {"lock"};
char lock_name[] = "lock";
char topic_name[LOCKCOUNT][256];
char topic_heartbeat[256];
char topic_reset[256];
char topic_analog[256];
char topic_calibrate[256];

/* Switch input pin numbers */
int switch_pins[LOCKCOUNT] = {0};

/* Photo sensor input pin numbers */
int sensor_pins[LOCKCOUNT] = {1};

/* LED output pin numbers */
int led_pins[LOCKCOUNT] = {4};

/* LED states (tracked by LED pin number */
int led_state[16];

/* The logic is a state-machine to handle sampling
 * versus being stuck in a reset error
 */
#define STATE_WORKING 0
#define STATE_FROZEN 1
#define STATE_ERROR 2
int logic_state = STATE_WORKING;
char state_names[3][256] = {"working", "frozen", "error"};

/* Function prototypes */
void mqtt_sub_callback(char *, unsigned char *, unsigned int);

/* Sample tracking stuff */
int freq = 150;
int scount = 0;

/* WIFI and MQTT */
char WLAN_SSID[] = "LockBox";
char WLAN_PASS[] = "407a81b1d887c4fbaf0b2e100b605f57";
WiFiClient client;
int status = WL_IDLE_STATUS;
byte mac[6];
IPAddress mqttServer(10, 133, 7, 1);
int mqttPort          = 1883;
char mqttUsername[]   = "";
char mqttPassword[]   = "";
PubSubClient mqtt(mqttServer, mqttPort, mqtt_sub_callback, client);


void setup() {

  int i;

  /* Build string resources */
  for (i = 0; i < LOCKCOUNT; i++) {
    snprintf((char *)&(topic_name[i]), 256, "%s/%s/%s",
	     game_name, lock_name, (char *)&(diff_name[i]));
  }

  /* Heartbeat topic */
  snprintf(topic_heartbeat, 256, "%s/%s/heartbeat", game_name, lock_name);

  /* Reset topic */
  snprintf(topic_reset, 256, "%s/reset", game_name);

  if (READMODE == ANALOG_MODE) {
    snprintf(topic_analog, 256, "%s/%s/analog", game_name, lock_name);
    snprintf(topic_calibrate, 256, "%s/%s/calibrate", game_name, lock_name);
  }

  //Initialize serial and wait for port to open:
  Serial.begin(9600);

  delay(2000); /* Make sure serial connects */

  /* Setup the pins for IO */
  pinMode(status_led, OUTPUT);
  for (i = 0; i < LOCKCOUNT; i++) {
    pinMode(switch_pins[i], INPUT);
    pinMode(led_pins[i], OUTPUT);
  }

  /* Turn off all the LEDs */
  set_led(status_led, LED_OFF);
  set_led(led_pins[0], LED_OFF);

  /* Report the MAC address */
  WiFi.macAddress(mac);
  Serial.print("MAC: ");
  Serial.print(mac[5],HEX);
  Serial.print(":");
  Serial.print(mac[4],HEX);
  Serial.print(":");
  Serial.print(mac[3],HEX);
  Serial.print(":");
  Serial.print(mac[2],HEX);
  Serial.print(":");
  Serial.print(mac[1],HEX);
  Serial.print(":");
  Serial.println(mac[0],HEX);

  /* Finally connect */
  set_led(status_led, LED_ON);
  MQTT_connect();
  set_led(status_led, LED_OFF);

  /* Setup the subscription */
  mqtt.setCallback(mqtt_sub_callback);
  subscribe_to_topic(topic_reset);

  if (READMODE == ANALOG_MODE) {
    subscribe_to_topic(topic_calibrate);
  }

  /* Now make sure we reset the state */
  do_reset();
}


void loop() {

  int i;
  int ret;
  int current_state[LOCKCOUNT];
  int analog_sample[LOCKCOUNT];
  char analog_readings[256];

  /* Turn off status LED */
  set_led(status_led, LED_OFF);

  /* Do the heartbeat */
  scount++;
  if (scount % 1000 == 0) {
     send_msg_to_mqtt(topic_heartbeat, state_names[logic_state]);

     /* Also report analog averages */
     if (READMODE == ANALOG_MODE) {
       sprintf(analog_readings, "%.03f", running_avg[0]);
       send_msg_to_mqtt(topic_analog, analog_readings);
     }
  }

  /* Make the LEDs blink on error */
  if (logic_state == STATE_ERROR) {
    if (scount % 1000 == 500) {
      toggle_led(led_pins[0]);
    }
  }

  /* Keep the scount value small so we don't overflow */
  if (scount > 1000) {
    scount -= 1000;
  }

  if (READMODE == DIGITAL_MODE) {
    if (logic_state == STATE_WORKING) {
      /* Read the lock state from all of the lock pins */
      for (i = 0; i < LOCKCOUNT; i++) {
	if (digitalRead(switch_pins[i]) == LOCK_CLOSED) {
	  current_state[i] = CLOSED_STATE;
	} else {
	  current_state[i] = OPEN_STATE;
	}
      }
    }
    else {
      /* We're not sampling, just fake the state */
      for (i = 0; i < LOCKCOUNT; i++) {
	current_state[i] = previous_state[i];
      }
    }
  } /* end digital */

  if (READMODE == ANALOG_MODE) {
    for (i = 0; i < LOCKCOUNT; i++) {
      analog_sample[i] = analogRead(sensor_pins[i]);
    }

    /* We have to start off the average with whatever the current value is */
    if (first_sample == 1) {
      for (i = 0; i < LOCKCOUNT; i++) {
	running_avg[i] = (float)analog_sample[i] * 1.0;
      }

      first_sample = 0; /* never do this again! */
    }


    for (i = 0; i < LOCKCOUNT; i++) {
      running_avg[i] -= (running_avg[i] * 1.0) / (smooth_factor * 1.0);
      running_avg[i] += (analog_sample[i] * 1.0) / (smooth_factor * 1.0);

      if (logic_state == STATE_WORKING) {
	if (running_avg[i] > thresholds[i]) {
	  current_state[i] = OPEN_STATE;
	}
	else {
	  current_state[i] = CLOSED_STATE;
	}
      }
      else {
	/* we're faking the state because we're frozen or error */
	current_state[i] = previous_state[i];
      }
    }
  } /* end analog */


  /* Now handle tracking of the lock states */
  for (i = 0; i < LOCKCOUNT; i++) {

    if (current_state[i] == previous_state[i]) {
      streak[i] += 1;
      //Serial.println(streak[i]);
    } else {
      //State has changed
      streak[i] = 0;
      previous_state[i] = current_state[i];

      alerted[i] = 0;
    }

    if (streak[i] > 1000) {
      streak[i] -= 1000;
    }

    if (logic_state != STATE_ERROR) {
      // Publish whatever state we're periodically
      if (streak[i] == freq) {
	// publish

	if ((logic_state == STATE_WORKING) &&
	    (current_state[i] != CLOSED_STATE)) {
	  /* A lock was just opened so freeze */
	  enter_frozen_state();
	}

	if (alerted[i] == 0) {
	  Serial.print((char *)&(topic_name[i]));
	  Serial.print(" -> ");
	  Serial.println((char *)&(state_name[current_state[i]]));
	  alerted[i] = 1;
	}
	send_msg_to_mqtt((char *)&(topic_name[i]),
			 (char *)&(state_name[current_state[i]]));

	set_led(led_pins[i], state_led[current_state[i]]);
      }
    }
  }


  /* Process MQTT events and stay connected */
  ret = mqtt.loop();
  if (ret == false) {
    MQTT_connect();
  }

  /* Avoid spinning too fast */
  delay(1);

}


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}


void connect_wifi() {

  /* This function will check the status of the wifi connection
   * and if it isn't connected, will connect wifi
   */

  int status;
  int waittry;

  //Serial.println("Checking WIFI status");
  status = WiFi.status();

  if (status == WL_CONNECTED) {
    return;
  }
  //Serial.print("Wifi Status was ");
  //Serial.println(status);

  waittry = 0;
  Serial.print("Attempting to connect to SSID: ");
  Serial.println(WLAN_SSID);
  status = WiFi.begin(WLAN_SSID, WLAN_PASS);
  while (status != WL_CONNECTED) {
    waittry++;
    if (waittry >= 50) {
      Serial.print("Re-attempting to connect to SSID: ");
      Serial.println(WLAN_SSID);
      status = WiFi.begin(WLAN_SSID, WLAN_PASS);

      waittry = 0;
    }
    else {
      Serial.print(".");
      delay(100); /* Wait for things to settle down */

      status = WiFi.status();
    }
  }
  Serial.println("== WiFi connected ==");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}


// Function to connect and reconnect as necessary to the MQTT server.
// Should be called in the loop function and it will take care if connecting.
void MQTT_connect() {
  int8_t ret;
  int waittry;

  /* Make sure we're connected to wifi first */
  connect_wifi();

  //Serial.print("Checking if MQTT connected... ");
  ret = mqtt.connected();

  if (ret == true) {
    //Serial.print("MQTT check connected passed... ");

    ret = mqtt.loop();
    //Serial.print("MQTT loop passed... ");

    if (ret == true) {
      // Serial.println("MQTT Connected!");
      return;
    }
  }

  waittry = 0;
  Serial.print("Connecting to MQTT");
  ret = mqtt.connect(lock_name);
  while (ret != true) { // connect will return true for connected
    if (waittry >= 50) {
      connect_wifi();
      Serial.println("");
      Serial.print("Retrying MQTT connection");
      ret = mqtt.connect(lock_name);

      waittry = 0;
    }
    else {
      Serial.print(".");

      delay(50);  // wait x ms
      ret = mqtt.loop();
    }

    waittry++;
  }
  Serial.println("");
  Serial.println("MQTT Connected!");

  mqtt.setCallback(mqtt_sub_callback);
  subscribe_to_topic(topic_reset);

  if (READMODE == ANALOG_MODE) {
    subscribe_to_topic(topic_calibrate);
  }
}


void send_msg_to_mqtt(const char *topic, const char *msg) {

  int ret;

  /*
   * Publish docs says (http://pubsubclient.knolleary.net/api.html#publish1)
   *
   * Returns
   *
   * false - publish failed, either connection lost, or message too large
   * true - publish succeeded
   */

  set_led(status_led, LED_ON);

  //Serial.print("Publishing to topic ");
  //Serial.println(topic);

  ret = mqtt.loop();
  ret = mqtt.publish(topic, msg);
  while (ret == false) {
    Serial.println("Publish failed, retrying");
    MQTT_connect();
    ret = mqtt.loop();
    ret = mqtt.publish(topic, msg);
  }

  set_led(status_led, LED_OFF);
}


void subscribe_to_topic(const char *topic) {

  int ret;

  /*
   * Subscribe docs says (http://pubsubclient.knolleary.net/api.html#subscribe)
   *
   * Returns
   *
   * false - sending the subscribe failed, either connection lost, or
   * message too large.
   *
   * true - sending the subscribe succeeded.
   * The request completes asynchronously.
   *
   */

  set_led(status_led, LED_ON);

  Serial.print("Subscribing to topic ");
  Serial.println(topic);

  ret = mqtt.loop();
  ret = mqtt.subscribe(topic);
  while (ret == false) {
    Serial.println("Subscribe failed, retrying");
    MQTT_connect();
    ret = mqtt.loop();
    ret = mqtt.subscribe(topic);
  }

  set_led(status_led, LED_OFF);
}


void mqtt_sub_callback(char *topic, unsigned char *payload,
		       unsigned int length) {

  char msg[256];
  int thresh[LOCKCOUNT];
  int ret;
  int i;

  //Serial.println("Got into callback");

  if (length > 255) {
    Serial.println("Got bogus long message");
  }
  else {
    strncpy(msg, (char *)payload, length);
    msg[length] = '\0';

    if (READMODE == ANALOG_MODE) {
      if (strcmp(topic, topic_calibrate) == 0) {
	/* It seems the Ardunio version of sscanf() doesn't support %f */
	ret = sscanf(msg, "%d", &(thresh[0]));

	if (ret != LOCKCOUNT) {
	  Serial.print("Got unparsable threshold calibration: ");
	  Serial.print(msg);
	  Serial.println("");
	}
	else {
	  for (i = 0; i < LOCKCOUNT; i++) {
	    Serial.print("Setting ");
	    Serial.print(diff_name[i]);
	    Serial.print(" lock threshold to ");
	    Serial.println(thresh[i]);

	    thresholds[i] = (float)thresh[i] * 1.0;
	  }
	}

	return;
      }
    }

    /* make sure this is the topic we were expecting */
    if (strcmp(topic, topic_reset) != 0) {
      Serial.print("Got message on unexpected topic ");
      Serial.print(topic);
      Serial.print(": ");
      Serial.print(msg);
      Serial.println("");
      return;
    }

    /* make sure the message is reset */
    if (strcmp(msg, "reset") != 0) {
      Serial.print("Got unexpeocted reset message: ");
      Serial.print(msg);
      Serial.println("");
      return;
    }

    /* okay do the reset */
    do_reset();
  }
}


void do_reset() {

  int i;
  int lockstate = LOCK_CLOSED;

  Serial.println("Attempting to reset...");

  /* all the locks had better be closed */
  for (i = 0; i < LOCKCOUNT; i++) {

    if (READMODE == DIGITAL_MODE) {
      if (digitalRead(switch_pins[i]) == LOCK_CLOSED) {
	lockstate = CLOSED_STATE;
      }
      else {
	lockstate = OPEN_STATE;
      }
    }

    if (READMODE == ANALOG_MODE) {
      /* We're always keeping a running average so just used that */
      if (running_avg[i] > thresholds[i]) {
	lockstate = OPEN_STATE;
      }
      else {
	lockstate = CLOSED_STATE;
      }
    }

    if (lockstate == OPEN_STATE) {
      Serial.print("Lock ");
      Serial.print(diff_name[i]);
      Serial.println(" is not closed!");

      enter_error_state();
      return;
    }
  }

  Serial.print("Resetting from ");
  Serial.print(state_names[logic_state]);
  Serial.println(" state");

  logic_state = STATE_WORKING;

  set_led(led_pins[0], LED_OFF);
}


void enter_error_state() {

  Serial.println("Going into an error state");
  set_led(led_pins[0], LED_ON);

  logic_state = STATE_ERROR;
}

void enter_frozen_state() {

  Serial.println("Going into frozen state");
  logic_state = STATE_FROZEN;
}


void set_led(int led, int state) {

  digitalWrite(led, state);

  if (state == LED_ON) {
    led_state[led] = LED_ON;
  }
  else {
    led_state[led] = LED_OFF;
  }
}


void toggle_led(int led) {

  if (led_state[led] == LED_ON) {
    set_led(led, LED_OFF);
  }
  else {
    set_led(led, LED_ON);
  }
}
