class profile::developer {
  include openssl
  include sqlite
  include git
  include ruby
  include libvirt

  $user = 'developer'
  $user_home = "/home/${user}"

  user { "${user}":
    ensure     => 'present',
    managehome => true,
  }

  class { "bash_aliases":
    user => $user,
    userhome => $user_home,
    require => User[$user]
  }

  class { "git_config":
    user => $user,
    userhome => $user_home,
    require => User[$user]
  }

  class {"ssh":
    allow_password_authentication => false
  }

  ssh::user {$user:
    user_home => $user_home,
    require => [ Class['ssh'], User[$user] ]
  }
}

