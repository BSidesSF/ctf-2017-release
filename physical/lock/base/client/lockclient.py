import datetime
import os
import os.path
import sys
import threading
import time

import paho.mqtt.client as mqtt
from PIL import Image
import RPi.GPIO as GPIO

import printer
import nonce

LOG_FILE = '/root/locklog'
STATE_TOPIC = 'ctf/lock/lock'
HEARTBEAT_TOPIC = 'ctf/lock/heartbeat'
RESET_TOPIC = 'ctf/reset'
MQTT_HOST = 'localhost'
LOGO = 'bsides_logo_gs.png'
KEY = 'make_me_a_secret'
UNLOCK_TIME = 3
HEARTBEAT_TIMEOUT = 10

# GPIO
RESET_GPIO = 25
LED_RED = 4
LED_GREEN = 17

LOCKED = 0
UNLOCKED = 1
PRINTED = 2
FAILED = 3


class LockClient(object):

    def __init__(self):
        printer.ThermalPrinter.BAUDRATE = 9600
        self.printer = printer.ThermalPrinter(serialport='/dev/ttyUSB0')
        self.logf = open(LOG_FILE, 'a')
        self.client = mqtt.Client()
        self.set_key(KEY)
        self.state = PRINTED  # Require reset
        self.state_time = 0
        self.heartbeat_time = time.time()
        self.lock = threading.Lock()

        # GPIO setup
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(RESET_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        GPIO.setup(LED_RED, GPIO.OUT)
        GPIO.setup(LED_GREEN, GPIO.OUT)

    def set_key(self, key):
        self.validator = nonce.Nonce_24_56_Base32_Validator(key)

    def print_image(self, impath):
        """Print an image."""
        try:
            impath = os.path.join(os.path.dirname(__file__), impath)
        except NameError:
            pass
        try:
            im = Image.open(impath)
        except IOError:
            print 'Unable to load image: %s' % impath
            return
        data = list(im.getdata())
        self.printer.print_bitmap(data, *im.size)

    def print_flag(self, flag, timestamp):
        """Print the whole flag output."""
        if not self.printer:
            return
        self.print_image(LOGO)
        self.printer.print_text("Nicely done.  How about a flag\n"
                                "for your troubles?\n")
        self.printer.print_text("%s\n" % flag)
        self.printer.print_text("\n")
        self.printer.print_text("Challenge lock picked at:\n")
        self.printer.print_text("%s\n" % timestamp)
        self.printer.linefeed(4)

    def handle_unlock(self):
        self.green_led()
        timestamp = self.timestamp
        flag = self.flag
        self.log("%s: Lock Unlocked: %s\n" % (timestamp, flag))
        try:
            self.print_flag(flag, timestamp)
        except Exception as ex:
            self.log("%s: Error while printing: %s\n",
                    timestamp, str(ex))

    @property
    def timestamp(self):
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%I:%S")

    @property
    def nonce(self):
        return int(time.time()) & 0xFFFFFF

    @property
    def flag(self):
        return self.validator.make_answer(self.nonce)

    def mqtt_on_connect(self, client, userdata, flags, rc):
        def subscribe(topic):
            self.client.subscribe(topic)
            self.log("%s: connected, subscribed to %s.\n" %
                    (self.timestamp, topic))
        subscribe(STATE_TOPIC)
        subscribe(HEARTBEAT_TOPIC)

    def mqtt_on_message(self, client, userdata, msg):
        if msg.topic == STATE_TOPIC:
            self.lock_state_handler(msg)
        elif msg.topic == HEARTBEAT_TOPIC:
            self.heartbeat_time = time.time()

    def lock_state_handler(self, msg):
        """State machine for lock."""
        with self.lock:
            if msg.payload == "open":
                if self.state == UNLOCKED:
                    if time.time() > (self.state_time + UNLOCK_TIME):
                        self.handle_unlock()
                        self.state = PRINTED
                    return
                if self.state == LOCKED:
                    self.state = UNLOCKED
                    self.state_time = time.time()
                    return
            elif msg.payload == "closed":
                self.state = LOCKED

    def connect(self):
        """Connect to MQTT broker."""
        self.client.on_connect = self.mqtt_on_connect
        self.client.on_message = self.mqtt_on_message
        self.client.connect(MQTT_HOST, 1883, 60)

    def run(self):
        """Run mqtt loop and threads."""
        self._heartbeat_thread = threading.Thread(target=self.heartbeat_watcher)
        self._heartbeat_thread.daemon = True
        self._heartbeat_thread.start()

        GPIO.add_event_detect(RESET_GPIO, GPIO.FALLING,
                callback=self.reset_handler)

        # Noreturn
        self.client.loop_forever()

    def log(self, msg, *args):
        if args:
            msg = msg % args
        if msg[-1] != "\n":
            msg += "\n"
        self.logf.write(msg)
        self.logf.flush()
        sys.stdout.write(msg)
        os.fsync(self.logf.fileno())

    def heartbeat_watcher(self):
        """Keep an eye on the heartbeat."""
        while True:
            time.sleep(HEARTBEAT_TIMEOUT)
            with self.lock:
                if time.time() > (self.heartbeat_time + HEARTBEAT_TIMEOUT):
                    self.log('%s: heartbeat timeout.' % self.timestamp)
                    # TODO: print an error receipt
                    self.clear_led()
                    self.red_led()
                    if self.state != FAILED:
                        self.printer.print_text(
                                'ERROR\nHeartbeat timeout\nERROR\n')
                        self.printer.linefeed(4)
                    self.state = FAILED

    def reset_handler(self, unused_channel):
        """Called on reset button press."""
        with self.lock:
            self.log('%s: reset button pressed.' % self.timestamp)
            self.client.publish(RESET_TOPIC, "reset", qos=1, retain=True)
            self.clear_led()

    @staticmethod
    def red_led():
        GPIO.output(LED_RED, True)

    @staticmethod
    def green_led():
        GPIO.output(LED_GREEN, True)

    @staticmethod
    def clear_led():
        GPIO.output((LED_RED, LED_GREEN), False)


if __name__ == '__main__':
    client = LockClient()
    print 'Testing printer...'
    flg = client.flag[4:-4]
    client.print_flag('TEST' + flg + 'TEST', client.timestamp)
    if 'test' in sys.argv:
        sys.exit(0)
    print 'Going for main.'
    # DEBUG
    client.connect()
    client.run()
