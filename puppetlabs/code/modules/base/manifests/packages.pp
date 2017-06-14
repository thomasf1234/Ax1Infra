class base::packages(
  $packages = [ "htop","ncdu", "vim", "curl"]
) {
  package { $packages:
    ensure => latest
  }
}