class profile::proxy {
  nginx::proxy { "go_server":
    proxy_listen => 80,
    proxy_pass => "http://localhost:8153",
    notify => Service["nginx"]
  }

  nginx::proxy { "yugioh_x2":
    proxy_listen => 2000,
    proxy_pass => "http://localhost:2000",
    notify => Service["nginx"]
  }

  service {'nginx':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Class["nginx"]
  }
}

