class ssh(
  $allow_password_authentication = true
) {
  package {'openssh-server':
    ensure => installed
  }

  if $allow_password_authentication == false {
    exec {"ensure cannot ssh via password":
      command => "sed -i 's/.*PasswordAuthentication yes.*/PasswordAuthentication no/' /etc/ssh/sshd_config",
      require => Package["openssh-server"],
      notify => Service["ssh"]
    }

    service {"ssh":
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package["openssh-server"]
    }
  }
}
