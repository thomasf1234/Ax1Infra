# __USAGE__
# nginx::proxy { "myproxy":
#   proxy_listen => 2000,
#   proxy_pass => "http://localhost:2000"
# }
# test with:
# ruby -run -e httpd . -p 2000

define nginx::proxy(
  $proxy_listen,
  $proxy_pass
) {
  $proxy_name = "${name}"
  include nginx

  file { "nginx ${proxy_name} config file":
    path    => "/etc/nginx/sites-available/${proxy_name}",
    owner   => root,
    group   => root,
    mode    => '644',
    replace => true,
    content => template("nginx/etc/nginx/sites-available/proxy.erb"),
    require => Class["nginx"]
  }

  file { "nginx ${proxy_name} config file symlink":
    path    => "/etc/nginx/sites-enabled/${proxy_name}",
    ensure  => link,
    target  => "/etc/nginx/sites-available/${proxy_name}",
    owner   => root,
    group   => root,
    require => [ Class["nginx"], File["nginx ${proxy_name} config file"] ]
  }
}