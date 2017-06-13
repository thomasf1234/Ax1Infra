class nginx::ssl {
  file { "nginx ssl directory":
    path    =>  "/etc/nginx/ssl",
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '755'
  }

  file { "nginx ssl certs directory":
    path    =>  "/etc/nginx/ssl/certs",
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '755',
    require => File["nginx ssl directory"]
  }

  file { "nginx ssl private directory":
    path    =>  "/etc/nginx/ssl/private",
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '700',
    require => File["nginx ssl directory"]
  }
}