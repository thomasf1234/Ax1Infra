class gocd::server {
  $cruise_config_path = "/etc/go/cruise-config.xml"
  $htpasswd_path = "/var/lib/go-server/htpasswd"
  $bootstrap_goserver_path = "/var/lib/go-server/bootstrap_goserver.rb"

  include gocd::apt_repo
  include ruby

  package { "go-server":
    ensure  => latest,
    require => Class["gocd::apt_repo"]
  }

  service { 'go-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package["go-server"]
  }

  file { $htpasswd_path:
    owner   => "go",
    group   => "go",
    mode    => '644',
    source  => 'puppet:///modules/gocd/var/lib/go-server/htpasswd',
    require => Service["go-server"]
  }

  file { $bootstrap_goserver_path:
    owner   => "go",
    group   => "go",
    mode    => '644',
    source  => 'puppet:///modules/gocd/var/lib/go-server/bootstrap_goserver.rb',
    require => Service["go-server"]
  }

  exec { "run_bootstrap_goserver":
    command => "ruby ${bootstrap_goserver_path}",
    require => File[$bootstrap_goserver_path]
  }
}
