#!/bin/bash

add_rfc3442_hook() {
  cat << EOF > /etc/initramfs-tools/hooks/add-rfc3442-dhclient-hook
#!/bin/sh

PREREQ=""

prereqs()
{
        echo "\$PREREQ"
}

case \$1 in
prereqs)
        prereqs
        exit 0
        ;;
esac

if [ ! -x /sbin/dhclient ]; then
        exit 0
fi

. /usr/share/initramfs-tools/scripts/functions
. /usr/share/initramfs-tools/hook-functions

mkdir -p \$DESTDIR/etc/dhcp/dhclient-exit-hooks.d/
cp -a /etc/dhcp/dhclient-exit-hooks.d/rfc3442-classless-routes \$DESTDIR/etc/dhcp/dhclient-exit-hooks.d/
EOF

  chmod +x /etc/initramfs-tools/hooks/add-rfc3442-dhclient-hook
}


# Install hook
add_rfc3442_hook

# Copy SSH keys for dropbear
mkdir -p /etc/dropbear-initramfs
cp -a /root/.ssh/authorized_keys /etc/dropbear-initramfs/authorized_keys

# override initramfs interface which is used for dhcp
{% if autoinstall_initramfs_override_interface %}
echo "DEVICE={{ autoinstall_initramfs_interface }}" >> /etc/initramfs-tools/initramfs.conf
{% endif %}

# Update system
apt-get update >/dev/null
apt-get -y install cryptsetup-initramfs dropbear-initramfs
