define utils::ubuntu_package(
  $ensure,
) {
  exec { "apt-get update for ${name}":
    command   => "apt-get update"
  }

  package { $name:
    ensure  => $ensure,
    require => Exec["apt-get update for ${name}"]
  }
}