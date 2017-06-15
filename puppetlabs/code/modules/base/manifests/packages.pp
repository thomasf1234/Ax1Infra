class base::packages(
  $packages = [ "htop","ncdu", "vim", "curl"]
) {
  file { "ax1package utility script":
    path => "/usr/local/bin/ax1package",
    owner => "root",
    group => "root",
    mode => "0755",
    replace => true,
    source => 'puppet:///modules/base/usr/local/bin/ax1package'
  }

  package { $packages:
    ensure => latest
  }
}