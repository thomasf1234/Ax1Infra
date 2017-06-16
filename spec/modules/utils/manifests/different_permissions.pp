Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }

node 'default' {
  utils::download {"test":
    source_url => "file:///tmp/test_package.tgz",
    destination_dir => "/var/tmp/",
    checksum_algorithm => 'SHA-256',
    owner => "nobody",
    group => "nogroup",
    mode => "777",
    checksum => "ce36c4f444d3a1e25571e5c7796ef2003c89e154ec37f09b3d7bb241615d53eb"
  }
}