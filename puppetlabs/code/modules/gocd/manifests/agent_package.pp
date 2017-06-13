class gocd::agent_package {
  include gocd::apt_repo

  package { "go-agent":
    ensure => latest,
    require => Class["gocd::apt_repo"]
  }

  file {
    "/etc/default/go-agent":
      ensure   => absent,
      force => true,
      backup => false,
      require => Package["go-agent"]
  }

  file { "/var/lib/go-agent":
    ensure   => absent,
    force => true,
    backup => false,
    require => Package["go-agent"]
  }

  file { "/var/log/go-agent":
    ensure   => absent,
    force => true,
    backup => false,
    require => Package["go-agent"]
  }

  #enforce diasable as it is update resistant
  exec { "disable default go-agent service":
    command => "update-rc.d go-agent disable",
    require => Package["go-agent"]
  }

  service { "go-agent":
    ensure => stopped,
    enable => false,
    require => Package["go-agent"]
  }
}
