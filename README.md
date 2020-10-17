midipi
======

midipi is a midicontrolled speech-synthesizer for the raspberry pi. It uses the WiringPI and UniMidi libraries to control the Magnevation Speakjet IC.

schematic
======

todo

configuration
======

- remove references to ttyAMA0 in /boot/cmdline.txt
	- to something like dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait


# os dependencies

apt-get install libasound2-dev libffi-dev ruby-dev libsqlite3-dev

