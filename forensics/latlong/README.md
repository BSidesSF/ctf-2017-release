
Generated with:
./ax25beacon -s "WDPX01" -o output.wav -- 37.780963 -122.392227 0 "flag{f4ils4f3c0mms}"

Solvable via:
```
sox -t wav output.wav -esigned-integer -b16 -r 22050 -t raw - | ./multimon-ng -A -
multimon-ng  (C) 1996/1997 by Tom Sailer HB9JNX/AE4WA
             (C) 2012-2014 by Elias Oenal
available demodulators: POCSAG512 POCSAG1200 POCSAG2400 FLEX EAS UFSK1200 CLIPFSK FMSFSK AFSK1200 AFSK2400 AFSK2400_2 AFSK2400_3 HAPN4800 FSK9600 DTMF ZVEI1 ZVEI2 ZVEI3 DZVEI PZVEI EEA EIA CCIR MORSE_CW DUMPCSV SCOPE
Enabled demodulators: AFSK1200
APRS: WDPX01>APRS:!/;E'q/Sz'O   /A=000000flag{f4ils4f3c0mms}
```
