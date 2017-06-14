class profile::yugioh_x2 {
  include sqlite
  include ruby
  include ssh

  $user = 'yugioh_x2'
  $user_home = "/home/${user}"

  user { $user:
    ensure     => 'present',
    managehome => true,
  }

  class { "bash_aliases":
    user => $user,
    userhome => $user_home,
    require => User[$user]
  }

  class { "yugioh_x2":
    server_port => 2000,
    server_root => "/opt/abstractx1/yugioh_x2",
    owner => $user,
    server_env => $environment,
    health_check_end_point => '/healthcheck',
    require => User[$user]
  }
}

