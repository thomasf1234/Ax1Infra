class lib::python_software_properties {
  exec{"apt-get-update-python_software_properties":
    command => "apt-get update"
  }
  package {'python-software-properties':
    ensure => latest,
    require => Exec["apt-get-update-python_software_properties"]
  }
}