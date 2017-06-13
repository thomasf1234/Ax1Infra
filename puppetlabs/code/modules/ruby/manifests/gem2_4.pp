define ruby::gem2_4 {
  exec { "gem2.4_install_${name}":
    command => "/usr/bin/gem2.4 install --no-user-install ${name} --bindir /usr/local/bin/ruby2.4",
    unless => "/usr/bin/gem2.4 list -i ^${name}$"
  }
}
