class libvirt {
  package {'qemu-kvm':
    ensure => latest,
    unless => "egrep '(vmx|svm)' /proc/cpuinfo"
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