class profile::gocd_base {
  $go_server_ip = "localhost"
  $go_server_port = "8153"
  $go_server_ssl_port = "8154"

  include sqlite
  include ruby
  include java8
  include ssh
  include git

  class { "gocd::server":
    require => Class["java8"]
  }

  class { "gocd::agent_package":
    require => [ Class["java8"], Class["gocd::server"] ]
  }

  gocd::agent { "go-agent-1":
    go_server_ip => $go_server_ip,
    go_server_port => $go_server_port,
    go_server_ssl_port => $go_server_ssl_port,
    go_agent_resources => ["builder", "provisioner"],
    require => Class["gocd::agent_package"]
  }

  gocd::agent { "go-agent-2":
    go_server_ip => $go_server_ip,
    go_server_port => $go_server_port,
    go_server_ssl_port => $go_server_ssl_port,
    go_agent_resources => ["builder", "provisioner"],
    require => Class["gocd::agent_package"]
  }

  ssh::user {'go':
    user_home => "/var/go",
    require => Class['ssh']
  }
}