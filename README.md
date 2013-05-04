midipi
======

- remove references to ttyAMA0 in /boot/cmdline.txt
	- to something like dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait

