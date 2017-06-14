Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }

stage { 'pre-main':
  before => Stage['main']
}

class { 'pre_main':
 stage => 'pre-main'
}

include base

node "default" {
  include role::developer
  include role::proxy
}

node "dev-gobase" {
  include role::gocd_base
}

node "ax1-yugiohx2" {
  include role::yugioh_x2
}

stage { 'post-main':
 require => Stage['main']
}

class {'post_main':
 stage => 'post-main'
}
