class nginx {
  utils::apt_repo {"passenger":
    list_source => "puppet:///modules/nginx/etc/apt/sources.list.d/passenger.xenial.list",
    key_source => "hkp://keyserver.ubuntu.com:80",
    key_id => "561F9B9CAC40B2F7",
    keyserver => true
  }

  package {'apt-transport-https':
    ensure => installed,
    require => Utils::Apt_Repo['passenger']
  }

  package {'ca-certificates':
    ensure => installed,
    require => Utils::Apt_Repo['passenger']
  }

  package {'nginx-extras':
    ensure => installed,
    reinstall_on_refresh => true,
    subscribe => Utils::Apt_Repo['passenger'],
    require => Utils::Apt_Repo['passenger']
  }
  
  package {'passenger':
    ensure => installed,
    reinstall_on_refresh => true,
    subscribe => Utils::Apt_Repo['passenger'],
    require => Utils::Apt_Repo['passenger']
  }
  
  class {'nginx::config':
    require => Package["nginx-extras"]
  }

  class {'nginx::ssl':
    require => Package["nginx-extras"]
  }
}