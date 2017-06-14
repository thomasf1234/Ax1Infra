class profile::yugioh_x2 {
  include sqlite
  include ruby
  include ssh

  $user = 'yugioh_x2'
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


}

