class java8 {
  $java_home = '/usr/lib/jvm/java-8-openjdk-amd64'
  $java_package = "openjdk-8-jdk-headless"

  package {"$java_package":
    ensure => installed
  }

  exec { 'update environment variables':
    command => "echo \"JAVA_HOME=${java_home}\" >> /etc/environment",
    unless => 'grep JAVA_HOME /etc/environment 2>/dev/null',
    require => Package["$java_package"]
  }
}
