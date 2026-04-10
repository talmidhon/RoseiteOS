#!/bin/bash
set -euo pipefail
echo "Executing Hermetic Lockdown..."
systemctl mask NetworkManager
systemctl mask wpa_supplicant
systemctl mask packagekit.service
systemctl mask packagekit-offline-update.service
cat <<EOF > /etc/modprobe.d/no-net.conf
blacklist iwlwifi
blacklist rtw88_8822ce
blacklist ath10k_pci
blacklist e1000e
blacklist r8169
EOF
rm -f /usr/bin/nmcli # כלי השליטה ברשת
rm -f /usr/bin/nmtui
passwd -l root
echo "ALL ALL=(ALL) !ALL" > /etc/sudoers.d/99-block-sudo
chmod 0440 /etc/sudoers.d/99-block-sudo
chmod a-s /usr/bin/sudo
chmod a-s /usr/bin/su
chmod 700 /usr/bin/flatpak
chmod 700 /usr/bin/rpm-ostree
chmod 700 /usr/bin/su
echo "Applying ONLYOFFICE restrictions..."
echo '<style>.document-creation-item[data-id="slide"], a.nav-item[data-value="Presentations"], #idx-sidebar-portals, li:has(a[action="external-panel-0"]), li:has(a[action="settings"]) { display: none !important; }</style>' | tee -a /opt/onlyoffice/desktopeditors/index.html
rm -rf /opt/onlyoffice/desktopeditors/editors/web-apps/apps/presentationeditor
echo "ONLYOFFICE restrictions applied successfully."
