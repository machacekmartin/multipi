0. Ensure you're using Raspberry PI5 
1. Connect the SD card into your system.
2. in run.sh modify DISK variable to match the SD card identifier (f.e. using diskutil list), mine is /dev/disk4
3. Execute sudo bash run.sh
4. Put the SD card into your PI
4. Start the PI. LibreELEC will be mounted, because it is marked as the first default in autoboot.txt
5. Install Arctic Horizon 2 skin
6. Add new Power Menu item with custom action labeled Batocera: System.Exec(/flash/reboot/reboot_into_batocera.sh)
7. Press this button and pi will reboot into Batocera
8. After your Pi boots into Batocera, press F1 and start terminal in Applications
9. Create LibreELEC.sh file in /userdata/roms/ports which will reboot into libreelec using the underlying reboot script:
    #!/bin/bash
    bash /boot/reboot/reboot_into_libreelec.sh
10. Refresh Game Library
11. Go to Ports section in library and run the script, which will reboot back to LibreELEC.
12. You've successfully set up "dual boot" using PI5 with LibreELEC and Batocera.