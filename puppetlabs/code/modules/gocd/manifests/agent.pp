define gocd::agent(
  $go_server_ip,
  $go_server_ssl_port,
) {

  file {
    "/etc/default/${name}":
      owner   => "root",
      group   => "go",
      mode    => '640',
      replace => true,
      content => template("gocd/etc/default/go-agent.erb"),
      require => Class["gocd::agent_package"]
  }

  file {
    "/etc/init.d/${name}":
      owner   => "root",
      group   => "root",
      mode    => '755',
      replace => true,
      source => "file:///etc/init.d/go-agent",
      require => Class["gocd::agent_package"]
  }

  exec {"update init script header info for ${name}":
    command => "sed -i 's/# Provides: go-agent$/# Provides: ${name}/g' /etc/init.d/${name}",
    require => File["/etc/init.d/${name}"]
  }

  file {
    "/var/lib/${name}":
      ensure => directory,
      owner   => "go",
      group   => "go",
      mode    => '750',
      require => Class["gocd::agent_package"]
  }

  file {
    "/var/log/${name}":
      ensure => directory,
      owner   => "go",
      group   => "go",
      mode    => '770',
      require => Class["gocd::agent_package"]
  }

  file {
    "/usr/share/${name}" :
      ensure => link,
      target => "/usr/share/go-agent",
      owner => root,
      group => root,
      mode => "755",
      require => Class["gocd::agent_package"]
  }

  exec { "add go-agent ${name} service":
    command => "update-rc.d ${name} defaults",
    require => [ Class["gocd::agent_package"], File["/etc/init.d/${name}"]]
  }

  service { $name:
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => File["/etc/default/${name}"],
    require => Exec["add go-agent ${name} service"]
  }
}
