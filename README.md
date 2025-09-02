# 🎮 Dualboot Batocera & LibreELEC on Raspberry Pi

My goal was to set up my Raspberry Pi 5 with a single SD card to handle both streaming movies and shows, as well as retro emulation gaming. I wanted to be able to control movies and shows using my TV remote, while using an Xbox controller for gaming.

### ⚠️ This is not a bullet-proof guide! 
Use your own head when navigating the repository. The repository is mainly for my personal use, but I thought it might be helpful to someone in the future who finds themselves in a situation similar to mine. Blindly following the guide could lead to serious mistakes, such as accidentally wiping or formatting the wrong drive—including your OS.


### Why didn't you use **xxx**
I decided to use LibreELEC for streaming and Batocera for gaming.

> Remember, I'm lazy
> 
    Q. Why not just install Batocera and use the built-in Kodi?
    A. Batocera's built-in kodi doesn't handle 4K HDR very well and is laggy, since it is not an OS optimised for video playback

    Q. Why not just install LibreELEC and use the built-in emulation?
    A. It was too complicated to install additional roms and bioses, and for some reason 3D games didn't work.
       I was also annoyed that the GUI wasn't optimized for gaming anymore + many many features were missing.

    Q. Why not use separate storage, one for each OS?
    A. PI5 has only 1 SD card slot by default and I have only 1 SD card lying around.

    Q. Why not use multi boot tool like PINN?
    A. When rebooting, PINN reboots into it's own GUI where you can pick which OS to boot. 
       The problem is that PINN doesn't support HDMI CEC in PI5 so I wouldn't be able to choose OS without having to reach for keyboard/mouse 
    
    Q. Why not use one RPI for each OS?
    A. lol

---

## TLDR; of this repository 
1. Prepare partitions for Batocera and LibreELEC (boot and root partitions) + default EFI partition for pi5 autoboot.
2. Paste contents of LibreELEC & Batocera images into their boot partitions. Also paste default autoboot.txt into EFI partition
3. Modify cmdline files to use prepared partitions
4. Copy custom reboot scripts into each OS
5. Setup shortcuts and buttons for rebooting into the opposite OS.

## More detailed description
> This repository was created on **macOS**. It may not work as expected on other operating systems.
> It relies on the following tools and utilities:
> `sudo`, `diskutil`, `mkfs.ext4 from e2fsprogs`, `dd`, `file`, `awk`, `grep`, `cut`, `brew`, `curl`, `gunzip`, `hdiutil`, `cp`, `mkdir`, `cat`


1. **Ensure Raspberry Pi 5** is being used.
2. **Insert the SD card** into your system.
3. Open `run.sh` and **modify the `DISK` variable** to match your SD card identifier.

   * Example: Use `diskutil list` to find the identifier (e.g., `/dev/disk4`).
4. Execute the script:

   ```bash
   sudo bash run.sh
   ```
5. **Insert the SD card** into your Raspberry Pi.
6. **Start the Pi.** LibreELEC will boot first as it is set as the default in `autoboot.txt`.
7. **Install Arctic Horizon 2 skin** (I'm familiar with this skin and it offers tons of customizability):
   [Arctic Horizon 2 Repository](https://jurialmunkey.github.io/repository.jurialmunkey/)
8. **Add a new Power Menu item** with a custom action:

   ```
   Label: Batocera
   Action: System.Exec(/flash/reboot/reboot_into_batocera.sh)
   ```
9. **Press the new menu button** to reboot the Pi into Batocera.
10. After Batocera boots, **press F1** to open a terminal in Applications.
11. **Create a script to reboot into LibreELEC**:

    ```bash
    #!/bin/bash
    bash /boot/reboot/reboot_into_libreelec.sh
    ```

    * Save it as `/userdata/roms/ports/LibreELEC.sh`.
12. **Refresh the Game Library** in Batocera.
13. Navigate to **Ports** and run the script to reboot back into LibreELEC.
---

🎉 🎉 🎉
