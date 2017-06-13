class lib::libpq {
  exec{"apt-get-update-libpq":
    command => "apt-get update"
  }
  package {'libpq-dev':
    ensure => latest,
    require => Exec["apt-get-update-libpq"]
  }
}