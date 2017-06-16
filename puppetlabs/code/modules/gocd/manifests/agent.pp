define gocd::agent(
  $go_server_ip,
  $go_server_port,
  $go_server_ssl_port,
  $go_agent_auto_register_key ='4280ef4d-48b6-42ec-9e0f-65d7dd05fe07',
  $go_agent_resources = []
) {
  $go_agent_name = $name

  file {
    "/etc/default/${go_agent_name}":
      owner   => "root",
      group   => "go",
      mode    => '640',
      replace => true,
      content => template("gocd/etc/default/go-agent.erb"),
      require => Class["gocd::agent_package"]
  }

  file {
    "/etc/init.d/${go_agent_name}":
      owner   => "root",
      group   => "root",
      mode    => '755',
      replace => true,
      source => "file:///etc/init.d/go-agent",
      require => Class["gocd::agent_package"]
  }

  exec {"update init script header info for ${go_agent_name}":
    command => "sed -i 's/# Provides: go-agent$/# Provides: ${go_agent_name}/g' /etc/init.d/${go_agent_name}",
    require => File["/etc/init.d/${go_agent_name}"]
  }

  file {
    "/var/lib/${go_agent_name}":
      ensure => directory,
      owner   => "go",
      group   => "go",
      mode    => '750',
      require => Class["gocd::agent_package"]
  }

  file {
    "/var/lib/${go_agent_name}/config":
      ensure  => directory,
      owner   => "go",
      group   => "go",
      mode    => '0775',
      require => File["/var/lib/${go_agent_name}"]
  }

  file {
    "/var/lib/${go_agent_name}/config/autoregister.properties":
      owner   => "go",
      group   => "go",
      mode    => '0664',
      replace => false,
      content => template("gocd/var/lib/go-agent/config/autoregister.properties.erb"),
      require => File["/var/lib/${go_agent_name}/config"]
  }

  file {
    "/var/log/${go_agent_name}":
      ensure => directory,
      owner   => "go",
      group   => "go",
      mode    => '770',
      require => Class["gocd::agent_package"]
  }

  file {
    "/usr/share/${go_agent_name}" :
      ensure => link,
      target => "/usr/share/go-agent",
      owner => root,
      group => root,
      mode => "755",
      require => Class["gocd::agent_package"]
  }

  exec { "add go-agent ${go_agent_name} service":
    command => "update-rc.d ${go_agent_name} defaults",
    require => [ Class["gocd::agent_package"], File["/etc/init.d/${go_agent_name}"]]
  }

  service { $go_agent_name:
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => File["/etc/default/${go_agent_name}"],
    require => Exec["add go-agent ${go_agent_name} service"]
  }
}
