class gocd::server {
  include gocd::apt_repo

  package { "go-server":
    ensure => latest,
    require => Class["gocd::apt_repo"]
  }

  service { 'go-server':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package["go-server"]
  }
}
