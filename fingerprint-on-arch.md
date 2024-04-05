#How to setup Fingerprint sensor on Manjaro (DELL)
1. Check lsusb if it shows the fingerprint sensor.

2. If it exists in lsusb then copy the device ID XXXX:YYYY

3. Check this ID, if it is supported by fprintd: lifprint — Supported Devices 1.3k

4. if yes, then run fprintd-enroll $USER

5. Reboot, then login with your fingerprint.