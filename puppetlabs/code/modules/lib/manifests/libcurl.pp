class lib::libcurl {
  package {'libcurl4-openssl-dev':
    ensure => latest
  }
}