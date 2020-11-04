#!/bin/bash
echo "Stay near the pc, you will have to enter root password for a few times"
sudo rfkill unblock all &> /dev/null
echo "Setting timezone and time sync..."
timedatectl set-timezone Europe/Moscow
timedatectl set-ntp true
git config --global user.name "Danila"
git config --global user.email "dghak@bk.ru"
echo "Installing additiional packages..."
yay -S i3status-rust-git clipman pulseaudio-modules-bt-git virtualbox-ext-oracle translate-shell obs-studio-wayland wlrobs zoom jmtpfs swaylock-effects-git yandex-disk spotify adbfs-rootless-git scrcpy nm-connection-editor networkmanager-openvpn hunspell hunspell-en_US hunspell-ru-aot-ieyo hyphen hyphen-en hyphen-ru ytop-bin --noconfirm --sudoloop
echo "Zoom configuration..."
cp /usr/share/applications/Zoom.desktop ~/.local/share/applications
sed -i 's+Exec=/usr/bin/zoom %U+Exec=env QT_QPA_PLATFORM=xcb /usr/bin/zoom %U+g' ~/.local/share/applications/Zoom.desktop
update-desktop-database ~/.local/share/applications &> /dev/null
echo "Finished!"
