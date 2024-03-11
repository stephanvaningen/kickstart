#
# Kickstart file created for %current_build%
# applied to %grub_label%
#
#
rhsm --organization="your-redhat-organisation-id-here" --activation-key="your-activation-key-here" # or 'cdrom'
text


%pre --log=/run/install/logs/install_pre.log
cable_adapter_name=$(ls /sys/class/net | grep en)
cat << EOF > /tmp/network-connect-dhcp
network --bootproto=dhcp --device=$cable_adapter_name --activate
EOF
%end


%packages
%end


%post --nochroot --log=/run/install/logs/install_post.log
#!/bin/bash
mkdir -p /mnt/sysimage/opt/my_install
cp  -avr `find . -name my_install` /mnt/sysimage/opt/
echo "sh /opt/my_install/install.sh" >> /mnt/sysimage/root/.bashrc
%end


# Keyboard layouts
keyboard --xlayouts='be (oss)'
lang nl_BE.UTF-8
timezone Europe/Brussels --utc
selinux --disabled
firstboot --disable
zerombr
clearpart --all --initlabel
autopart --type=lvm --encrypted --passphrase='your-disk-passphrase-here' # to be removed after user-input
%include /tmp/network-connect-dhcp
firewall --enabled --http --smtp --ssh


rootpw --iscrypted your-crypted-password-here
user --groups=wheel,root --name=local_admin --password=your-other-crypted-passwod-here --iscrypted --gecos="Local Admin"


reboot
