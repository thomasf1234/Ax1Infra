class lib::build {
  package {'bison':
    ensure => latest
  }
  
  package {'build-essential':
    ensure => latest
  }
}