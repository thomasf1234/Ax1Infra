define utils::apt_repo(
  $list_source,
  $key_source,
  $key_id,
  $keyserver=false,
  $packages = ["apt-transport-https"]
) {
  $list_file_name = utils_basename($list_source)
  ##sudo apt-get install apt-transport-https
  exec {"sudo apt-get install apt-transport-https_$name":
    command => "sudo apt-get -q -y -o DPkg::Options::=--force-confold install  apt-transport-https",
  }
  ->
  file {"add ${name} APT repository":
    path => "/etc/apt/sources.list.d/${$list_file_name}",
    owner => 'root',
    group => 'root',
    source => $list_source,
  }

  if $keyserver {
    exec {"Install ${name} apt-repo key":
      command => "apt-key adv --keyserver ${key_source} --recv-keys ${key_id}"
    }
  } else {
    exec {"Install ${name} apt-repo key":
      command => "wget --quiet -O - ${key_source} | sudo apt-key add -",
      unless => "apt-key list | grep -w ${key_id}",
      require => File["add ${name} APT repository"]
    }
  }


  exec { "apt-get update after adding ${name} APT repository":
    command => "apt-get update",
    tries   => 3,
    timeout => 0,
    refreshonly => true,
    subscribe => Exec["Install ${name} apt-repo key"],
    require => Exec["Install ${name} apt-repo key"]
  }
}