class pre_main {
  exec { "package repository update":
    command => "apt-get update",
    tries => 3,
    try_sleep => 5
  }

  exec { "packages update":
    command => "apt-get --yes upgrade",
    tries => 3,
    try_sleep => 5,
    require => Exec["package repository update"]
  }
}
