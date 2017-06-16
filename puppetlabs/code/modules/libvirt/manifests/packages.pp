class libvirt::packages {
  utils::ubuntu_package {'qemu-kvm':
    ensure => latest
  }

  #http://manpages.ubuntu.com/manpages/xenial/man1/virt-install.1.html
  utils::ubuntu_package {'virtinst':
    ensure => latest
  }

  utils::ubuntu_package {'libvirt-bin':
    ensure => latest
  }

  utils::ubuntu_package {'bridge-utils':
    ensure => latest
  }

  utils::ubuntu_package {'virt-manager':
    ensure => latest
  }
}