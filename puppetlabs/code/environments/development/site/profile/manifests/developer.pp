class profile::developer {
  include openssl
  include sqlite

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

  include ssh

  ssh::user {$user:
    user_home => $user_home,
    require => [ Class['ssh'], User[$user] ]
  }

  exec {"ensure cannot ssh via password":
    command => "sed -i 's/.*PasswordAuthentication yes.*/PasswordAuthentication no/' /etc/ssh/sshd_config",
    require => Class["ssh"],
    notify => Service["ssh"]
  }

  service {"ssh":
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Class["ssh"]
  }

  include git
  include ruby
}

