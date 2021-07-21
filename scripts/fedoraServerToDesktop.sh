#!/bin/bash

# Check for sudo
DIRECTORY=$(cd `dirname $0` && pwd)
has_sudo_access=""
`timeout -k .1 .1 bash -c "sudo /bin/chmod --help" >&/dev/null 2>&1` >/dev/null 2>&1
if [ $? -eq 0 ];then
   has_sudo_access="YES"
	echo "Hey $USER! My old friend..."
	sleep 2
else
   has_sudo_access="NO"
	echo "$USER, you're not using sudo..."
	echo "Please use 'sudo ./setup.sh' to install the scripts."
	exit
fi

# Establish variables
neededPackages='gedit nemo-fileroller ytop libatomic ffmpeg ffmpeg-libs vlc eog libXScrnSaver utils-linux-user fish rhythmbox filezilla gnome-software plank firefox libreoffice'
cinnamon="Cinnamon Desktop Environment"
gnome="GNOME Desktop Environment"
desiredDM=""
desiredDE=""
desiredShell=""

# Enabling RPMFusion repositories. Free and Non-Free
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Ask for which DE to use.
echo "[1] - GNOME Desktop Environment"
echo "[2] - Cinnamon Desktop Environment"
echo "[3] - KDE Plasma Environment"
echo "[4] - Xfce Desktop Environment"
echo "[5] - Deepin Desktop Environment"
echo "[6] - MATE Desktop Environment"
echo "[7] - LXDE Desktop Environment"
echo "[8] - LXQt Desktop Environment"
echo ""

while true
do
 read -r -p "Which Desktop Environment would you like? [1-8]: " input
 
 case $input in
     [1])
 desiredDE="GNOME Desktop Environment"
 desiredDM="gdm"
 break
 ;;
     [2])
 desiredDE="Cinnamon Desktop Environment"
 desiredDM="lightdm"
 break
 ;;
     [3])
 desiredDE="KDE Plasma Workspaces"
 desiredDM="sddm"
 break
 ;;
     [4])
 desiredDE="Xfce Desktop"
 desiredDM="lightdm"
 break
 ;;
     [5])
 desiredDE="Deepin Desktop"
 desiredDM="lightdm"
 break
 ;;
     [6])
 desiredDE="MATE Desktop"
 desiredDM="lightdm"
 break
 ;;
     [7])
 desiredDE="LXDE Desktop"
 desiredDM="lxdm"
 break
 ;;
     [8])
 desiredDE="LXQt Desktop"
 desiredDM="sddm"
 break
 ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

dnf group install $desiredDE

dnf install $neededPackages -y

# Ask for which Shell to use.
echo "[1] - Bash"
echo "[2] - Fish"
echo ""

while true
do
 read -r -p "Which Shell Environment would you like to use? [1/2]: " input
 
 case $input in
     [1])
 desiredShell="/bin/bash"
 break
 ;;
     [2])
 desiredShell="/bin/fish"
 break
 ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

chsh $desiredShell

echo "Enabling $desiredDM now..."
sleep 2
systemctl enable --now $desiredDM
