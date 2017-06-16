#TODO : put verify path into /tmp
define utils::download (
  $source_url,
  $destination_dir = "/tmp",
  $checksum_algorithm,
  $checksum,
  $owner = $facts["identity"]["user"],
  $group = $facts["identity"]["group"],
  $mode = "644",
  $userpass = undef
) {
  $source_name = utils_basename($source_url)
  $destination = utils_file_join($destination_dir, $source_name)
  $curl_default_command = "curl -k ${source_url} -o ${destination}"
  $thirty_minutes = 1800

  $cleaned_name = regsubst($name,' ','_','G')

  if $userpass == undef {
    $curl_command = $curl_default_command
  } else {
    $curl_command = "${curl_default_command} -u ${$userpass}"
  }

  if ( utils_file_exists($destination) == true ) and ( utils_checksum($destination,$checksum_algorithm) == $checksum ) {
    notify{"${cleaned_name} utils::download using $destination $existing_checksum matches $checksum. Skipping download ":}
  }
  else {
    notify{"${cleaned_name} utils::download downloading new $source_url checksum didnt match":}

    exec { "${cleaned_name}-download_file":
      command => "${curl_command}",
      timeout => $thirty_minutes,
      require => Notify["${cleaned_name} utils::download downloading new $source_url checksum didnt match"]
    }

    file {"$destination":
      owner => $owner,
      group => $group,
      mode  => $mode,
      require => Exec["${cleaned_name}-download_file"]
    }

    case $checksum_algorithm {
      'SHA-256': {
        $verify_name =  "${source_name}_verify.sha256"
        $verify_path = utils_file_join("/tmp", $verify_name)

        file { $verify_path:
          content => "${checksum} ${destination}",
          replace => true,
          ensure => present
        }

        exec { "${cleaned_name}-verify_checksum":
          command => "sha256sum -c ${verify_path}",
          require => [ Exec["${cleaned_name}-download_file"], File[$verify_path] ]
        }

        notify{"${cleaned_name} utils::download $checksum matched download suceeded":
          require => Exec["${cleaned_name}-verify_checksum"]
        }
      }

      default: {
        fail("Checksum algorithm not supported.")
      }
    }
  }
}
