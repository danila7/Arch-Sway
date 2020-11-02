#!/bin/bash
mount -a
locale-gen
hwclock --systohc
timedatectl set-timezone Europe/Moscow
timedatectl set-ntp true
localectl set-locale LANG=en_US.UTF-8
pacman -Syyu
systemctl enable NetworkManager
rm /etc/mkinitcpio.conf
echo 'MODULES=""
BINARIES=""
FILES=""
HOOKS="base udev autodetect modconf block encrypt btrfs filesystems keyboard fsck"' > /etc/mkinitcpio.conf
mkinitcpio -P
bootctl --path=/boot install
echo "default arch" > /boot/loader/loader.conf
echo "title           Arch Linux
linux           /vmlinuz-linux
initrd          /intel-ucode.img
initrd          /initramfs-linux.img
options         cryptdevice=PARTLABEL=cryptsystem:luks:allow-discards root=LABEL=system rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf
pacman -S ttf-dejavu gnu-free-fonts noto-fonts noto-fonts-extra ttf-hack noto-fonts-emoji zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps clementine udiskie udisks2 htop gnome-icon-theme gnome-icon-theme-extras qt5ct meson ninja scdoc brightnessctl playerctl mako acpi qbittorrent virtualbox virtualbox-host-modules-arch gimp code libreoffice-fresh xorg-server-xwayland xdg-user-dirs ffmpeg youtube-dl jdk14-openjdk jdk8-openjdk mpv imv tmux openssh wget fish pulseaudio pulseaudio-alsa firefox bemenu-wlroots libva-intel-driver telegram-desktop ttf-opensans wofi git sway alacritty neofetch pavucontrol ranger grim slurp jq wl-clipboard swaylock ttf-fira-code neofetch android-tools atool bzip2 cpio gzip lhasa lzop p7zip tar unace unrar unzip xz zip gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav --noconfirm
echo "keyserver hkp://pool.sks-keyservers.net
keyserver https://sks-keyservers.net/
keyserver https://keys.mailvelope.com/
keyserver https://keys.openpgp.org/" >> /root/.gnupg/dirmngr.conf
read -sp 'Root password: ' rpass
echo "$rpass
$rpass" | passwd
read -p 'Username: ' uname
useradd -mG wheel,video,uucp,lock,vboxusers -s /usr/bin/fish $uname
read -sp "Enter $uname password: " upass
echo "$upass
$upass" | passwd $uname
cp /root/.gnupg/dirmngr.conf /home/$uname/.gnupg/dirmngr.conf
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo 'ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{UDISKS_FILESYSTEM_SHARED}="1"' > /etc/udev/rules.d/99-udisks2.rules
git config --global user.name "Danila"
git config --global user.email "dghak@bk.ru"
su - $uname -c 'xdg-user-dirs-update'
su - $uname -c 'set fish_greeting'
mkdir /home/$uname/Pictures/screenshots
mv /Wallpapers /home/$uname/Pictures/
mv /.local /home/$uname/
mv /.config /home/$uname/
mv after_install.sh /home/$uname/
git clone https://aur.archlinux.org/yay-bin.git /tmp/aurbuild
chmod 777 /tmp/aurbuild
su - $uname -c 'cd /tmp/aurbuild; makepkg -s'
pacman -U /tmp/aurbuild/*.pkg.* --noconfirm
rm -rf /tmp/aurbuild
echo "MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt5ct
CLUTTER_BACKEND=wayland
SDL_VIDEODRIVER=wayland
BEMENU_BACKEND=wayland
_JAVA_AWT_WM_NONREPARENTING=1
EDITOR=nvim
JAVA_HOME=/opt/intellij-idea-ce/jbr
TDESKTOP_DISABLE_GTK_INTEGRATION=1
GRIM_DEFAULT_DIR=/home/$uname/Pictures/screenshots
" >> /etc/environment
echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
udevadm control --reload-rules
udevadm trigger
echo "Enter your swapfile size in MiB"
read -p 'Swap size : ' swsize
truncate -s 0 /swap/swapfile
chattr +C /swap/swapfile
btrfs property set /swap/swapfile compression none
dd if=/dev/zero of=/swap/swapfile bs=1M count=$swsize status=progress
chmod 600 /swap/swapfile
mkswap /swap/swapfile
swapon /swap/swapfile
echo "/swap/swapfile          none            swap            defaults        0 0" >> /etc/fstab
