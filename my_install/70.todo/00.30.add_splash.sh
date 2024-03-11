#!/usr/bin/bash


# Copy splash to file system
local_filesystem_splash="/opt/OEM/splash.png"
cp -p "${bundle_directory}/splash.png" "${local_filesystem_splash}"


# Add splash to grub default
if ! grep -q '^GRUB_BACKGROUND=' /etc/default/grub; then
    echo "GRUB_BACKGROUND=\"${local_filesystem_splash}\"" | sudo tee -a /etc/default/grub > /dev/null
else
    sudo sed -i "s|^GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"${local_filesystem_splash}\"|" /etc/default/grub
fi


# apply default grub to running config
if [ -d /sys/firmware/efi ]; then
    echo ":  EFI boot detected, running mkconfig ..."
    sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
else
    echo ":  BIOS (Legacy) boot detected, running mkconfig ..."
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
fi
