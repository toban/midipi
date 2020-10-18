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


building programs
======

```
pi@raspberrypi:~/midipi/src $ sudo ruby main.rb --message="HELLO WORLD"
```

will output the program ruby file in the console like this

```
$programs << Program.new(
{
	:hello	 => [183, 8, 134, 145, 8, 14, 137],
	:world	 => [147, 8, 14, 176, 145, 174],
},7, "Untitled program")

```

example program
======
```
$programs << Program.new(
{
	:ice=> [8, 14, 155, 187],
	:hockey => [183, 8, 14, 135, 194, 8, 128],
	:you => [158, 8, 14, 139],
	:make => [140, 130, 194],
	:goal => [179, 8, 14, 137, 145],
	:great => [179, 148, 130, 191],
	:job => [165, 8, 14, 135, 170],
	:play=> [198, 145, 130]
	


},5, "ice hockey")

```

