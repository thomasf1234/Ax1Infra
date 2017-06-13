class ruby::ruby2_4 {
  file { "ruby2.4 bin dir":
    path => '/usr/local/bin/ruby2.4',
    ensure => directory,
    owner  => "root",
    group  => "root",
    mode => '755'
  }

  package {'ruby2.4':
    ensure => installed,
  }

  package {'ruby2.4-dev':
    ensure => installed,
  }
}