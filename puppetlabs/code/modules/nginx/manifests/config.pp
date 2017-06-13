class nginx::config {
  file {"remove default nginx passenger.conf":
    path => "/etc/nginx/passenger.conf",
    ensure => absent,
    force => true
  }

  file {"remove default nginx server":
    path => "/etc/nginx/sites-available/default",
    ensure => absent,
    force => true,
    require => Package["nginx-extras"]
  }

  file {"remove default nginx server symlink":
    path => "/etc/nginx/sites-enabled/default",
    ensure => absent,
    force => true,
    require => Package["nginx-extras"]
  }

  file {"nginx passenger.conf":
    path => "/etc/nginx/conf.d/passenger.conf",
    owner => 'root',
    group => 'root',
    mode => '644',
    source => "puppet:///modules/nginx/etc/nginx/conf.d/passenger.conf"
  }
  
  file {"nginx logger.conf":
    path => "/etc/nginx/conf.d/logger.conf",
    owner => 'root',
    group => 'root',
    mode => '644',
    source => "puppet:///modules/nginx/etc/nginx/conf.d/logger.conf"
   }
   
  file {"nginx cache.conf" :
    path => "/etc/nginx/conf.d/cache.conf",
    owner => 'root',
    group => 'root',
    mode => '644',
    source => "puppet:///modules/nginx/etc/nginx/conf.d/cache.conf"
  }
}