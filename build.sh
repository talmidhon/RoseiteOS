#!/bin/bash
# עדכון והתקנת כלי בנייה
sudo apt-get update
sudo apt-get install -y live-build

# יצירת תיקיית בנייה
mkdir live-custom && cd live-custom
lb config --binary-images iso-hybrid --architectures amd64

# 1. רשימת חבילות להתקנה (רק מה שצריך)
cat <<EOF > config/package-lists/my.list.chroot
gnome-core
onlyoffice-desktopeditors
curl
ca-certificates
EOF

# 2. סקריפט התקנה ל"זית" ונעילה (Hooks)
mkdir -p config/hooks/live
cat <<EOF > config/hooks/live/01-install-zayit-and-lock.chroot
#!/bin/sh
# התקנת זית
curl -L https://zayitapp.com/download/launch.linux -o /tmp/install_zayit.sh
sed -i 's/sudo //g' /tmp/zayit_install.sh
chmod +x /tmp/zayit_install.sh
DEBIAN_FRONTEND=noninteractive yes "" | bash /tmp/zayit_install.sh

# נעילה: הסרת טרמינל, רשת ודפדפן
apt-get purge -y gnome-terminal xterm network-manager firefox-esr wget curl
apt-get autoremove -y

# ביטול sudo
delgroup user sudo || true
EOF

# הרצת הבנייה
sudo lb build
