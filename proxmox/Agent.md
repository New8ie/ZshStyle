# Linux
On Linux you have to simply install the qemu-guest-agent, please refer to the documentation of your system.

We show here the commands for Debian/Ubuntu and Redhat based systems:

on Debian/Ubuntu based systems (with apt-get) run:

```sh
apt-get install qemu-guest-agent
```

and on Redhat based systems (with yum):
```sh
yum install qemu-guest-agent
```

Depending on the distribution, the guest agent might not start automatically after the installation.

Start it either directly with
```sh
systemctl start qemu-guest-agent
```
Then enable the service to autostart
```sh
systemctl enable qemu-guest-agent
```

# Windows

First you have to download the virtio-win driver iso (see Windows VirtIO Drivers).

Then install the virtio-serial driver:

1. Attach the ISO to your windows VM (virtio-*.iso)
2. Go to the windows Device Manager
3. Look for "PCI Simple Communications Controller"
4. Right Click -> Update Driver and select on the mounted iso in DRIVE:\vioserial\<OSVERSION>\ where <OSVERSION> is your Windows Version (e.g. 2k12R2 for Windows 2012 R2)

![proxmox1 screenshot][proxmox1]

After that, you have to install the qemu-guest-agent:

1. Go to the mounted ISO in explorer
2. The guest agent installer is in the directory guest-agent
3. Execute the installer with double click (either qemu-ga-x86_64.msi (64-bit) or qemu-ga-i386.msi (32-bit)

After that the qemu-guest-agent should be up and running. You can validate this in the list of Window Services, or in a PowerShell with:
```sh
PS C:\Users\Administrator> Get-Service QEMU-GA

Status   Name               DisplayName
------   ----               -----------
Running  QEMU-GA            QEMU Guest Agent
```
If it is not running, you can use the Services control panel to start it and make sure that it will start automatically on the next boot.



[proxmox1]: https://github.com/New8ie/MyFresh-Install/blob/main/screenshot/Screen-vioserial-driver.png
[proxmox2]: https://github.com/New8ie/MyFresh-Install/blob/main/screenshot/Screen-vioserial-device-manager.png