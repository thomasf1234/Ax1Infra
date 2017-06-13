define utils::download (
  $source_url,
  $destination_dir = "/tmp",
  $checksum_algorithm,
  $checksum,
  $userpass = undef
) {
  $source_name = utils_basename($source_url)
  $destination = utils_file_join($destination_dir, $source_name)
  $curl_default_command = "curl -k ${source_url} -o ${$destination}"

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
      require => Notify["${cleaned_name} utils::download downloading new $source_url checksum didnt match"]
    }

    case $checksum_algorithm {
      'SHA-256': {
        $verify_path = "${destination}_${cleaned_name}_verify.sha256"

        file { "${cleaned_name}-checksum":
          path => "${verify_path}",
          content => "${checksum} ${destination}",
          ensure => present
        }

        exec { "${cleaned_name}-verify_checksum":
          command => "sha256sum -c ${verify_path}",
          require => [ Exec["${cleaned_name}-download_file"], File["${cleaned_name}-checksum"] ]
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
