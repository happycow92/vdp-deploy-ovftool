1. Place the VDP OVF in the /root folder of the Linux appliance
2. Download the script and place it in the /root folder
3. If the Linux VM has internet access, then the script will download and install ovf tool
If not, it will exit the script and you will have to manually install ovf tool on linux and then run the script

4. If the script detects the ovftool is already install it will proceed further with the install where user inputs are requested.