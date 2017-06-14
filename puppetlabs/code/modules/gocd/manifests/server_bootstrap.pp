class gocd::server_bootstrap {
  $bootstrap_goserver_path = "/var/lib/go-server/bootstrap_goserver.rb"
  include ruby

  file { $bootstrap_goserver_path:
    owner   => "go",
    group   => "go",
    mode    => '644',
    source  => 'puppet:///modules/gocd/var/lib/go-server/bootstrap_goserver.rb'
  }

  exec { "run_bootstrap_goserver":
    command => "ruby ${bootstrap_goserver_path}",
    require => File[$bootstrap_goserver_path]
  }
}