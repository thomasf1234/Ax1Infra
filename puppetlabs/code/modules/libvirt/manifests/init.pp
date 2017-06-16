class libvirt {
  class {"libvirt::packages":}

  service {'libvirtd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Class["libvirt::packages"]
  }
}