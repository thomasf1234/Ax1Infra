class lib::libssldev {
  package {'libssl-dev':
    ensure => latest
  }
}