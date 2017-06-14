class gocd::server {
  include gocd::apt_repo
  include ruby

  utils::ubuntu_package { "go-server":
    ensure  => latest,
    require => Class["gocd::apt_repo"]
  }

  service { 'go-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package["go-server"]
  }

  class { "gocd::server_bootstrap":
    require => Service["go-server"]
  }
}
