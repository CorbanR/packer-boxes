#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "Installing VMware Tools"
    apt-get install -y linux-headers-$(uname -r) build-essential perl

    cd /tmp
    mkdir -p /mnt/cdrom
    mount -o loop /home/vagrant/linux.iso /mnt/cdrom
    tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/

    #See https://gist.github.com/lamw/bae9687faa14c7d7ee18
    cat > /tmp/answer << __ANSWER__
    yes
    /usr/bin
    /etc
    /etc/init.d
    /usr/sbin
    /usr/lib/vmware-tools
    yes
    /usr/share/doc/vmware-tools
    yes
    yes
    no
    no
    yes
    no
__ANSWER__

    /tmp/vmware-tools-distrib/vmware-install.pl < /tmp/answer
    rm /home/vagrant/linux.iso
    umount /mnt/cdrom
    rmdir /mnt/cdrom

#    apt-get -y remove linux-headers-$(uname -r) build-essential perl
#    apt-get -y autoremove
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "Installing VirtualBox guest additions"

    apt-get install -y linux-headers-$(uname -r) build-essential perl
    apt-get install -y dkms

    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso
fi
