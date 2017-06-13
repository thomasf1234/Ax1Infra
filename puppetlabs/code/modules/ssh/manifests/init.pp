class ssh {
  package {'openssh-server':
    ensure => installed
  }
}
