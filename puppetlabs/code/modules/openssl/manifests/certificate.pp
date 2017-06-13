define openssl::certificate(
  $keyout,
  $certout,
  $country="GB",
  $organization="The Football Pools",
  $common_name,
  $days,
  $unless=undef
) {
  $exec_title = "generate ssl certificate ${certout}"
  $command = "openssl req -x509 -nodes -days ${days} -newkey rsa:2048 -keyout ${keyout} -out ${certout} -subj \"/C=${country}/O=${organization}/CN=${common_name}\""

  if $unless {
    exec {$exec_title:
      command => $command,
      unless => $unless
    }
  } else {
    exec {$exec_title:
      command => $command,
    }
  }


  # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=GB/O=The Football Pools/CN=go_server.sportech.tld"
}