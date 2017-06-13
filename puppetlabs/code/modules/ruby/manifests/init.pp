class ruby {
  include ruby::dependencies

  exec {'add brightbox repo to sources.list.d':
    command => "apt-add-repository -y ppa:brightbox/ruby-ng",
    unless => "apt-cache policy ruby2.4 | grep brightbox"
  }

  exec { 'apt get update after adding brightbox':
    command => 'apt-get update',
    tries   => 3,
    timeout => 0,
    require => Exec['add brightbox repo to sources.list.d']
  }

  class {'ruby::ruby2_4':
    require => [ Exec['apt get update after adding brightbox'], Class['ruby::dependencies'] ]
  }

  ruby::gem2_4 {'bundler':
    require => Class['ruby::ruby2_4']
  }
}
