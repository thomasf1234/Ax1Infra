define ssh::user($user_home) {
  file { ".ssh":
    path => "${user_home}/.ssh",
    ensure => directory,
    owner  => "${name}",
    group  => "${name}",
    mode => '700'
  }
  
  file { "ssh authorized_keys file":
    path => "${user_home}/.ssh/authorized_keys",
    ensure => file,
    owner  => "${name}",
    group  => "${name}",
    mode => '600',
    require => File[".ssh"]
  }
  
}
