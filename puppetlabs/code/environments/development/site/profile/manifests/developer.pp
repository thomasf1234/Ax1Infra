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

  utils::download { "download ubuntu-16.04.2-server-amd64.iso":
    source_url => "http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso",
    destination_dir => "/var/lib/libvirt/images/",
    checksum_algorithm => "SHA-256",
    checksum => "737ae7041212c628de5751d15c3016058b0e833fdc32e7420209b76ca3d0a535",
    owner => "libvirt-qemu",
    group => "kvm",
    mode => "644",
    require => Class["libvirt"]
  }

  # virt_install { "",
  #
  # }
}

