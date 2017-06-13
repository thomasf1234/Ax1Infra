class libvirt {
  package {'qemu-kvm':
    ensure => latest
  }

  package {'libvirt-bin':
    ensure => latest
  }

  package {'bridge-utils':
    ensure => latest
  }

  package {'virt-manager':
    ensure => latest
  }
}