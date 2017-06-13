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

stage { 'post-main':
 require => Stage['main']
}

class {'post_main':
 stage => 'post-main'
}
