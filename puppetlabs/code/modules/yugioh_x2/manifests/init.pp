class yugioh_x2 (
  $server_port,
  $server_root,
  $owner,
  $server_env,
  $health_check_end_point
) {
  $bundle_executable = "/usr/local/bin/ruby2.4/bundle"
  $artifact_source_content = file("yugioh_x2/sources/yugioh_x2-release.tgz.json")
  $artifact_source = utils_json_parse($artifact_source_content)

  $server_pid_path = utils_file_join($server_root, "tmp/pids/server.pid")
  exec {"ensure ${owner} is stopped":
    command => "${bundle_executable} exec rake admin:server:stop",
    cwd => $server_root,
    onlyif => "test -f ${server_pid_path}"
  }

  # utils::download { "${service_name} artifact":
  #   source_url => $artifact_source['goartifact_source_url'],
  #   destination_dir => "$workingdir",
  #   checksum_algorithm => $artifact_source['checksum_algorithm'],
  #   checksum => $artifact_source['checksum'],
  #   userpass => 'dev:dev',
  #   require => Exec["ensure ${service_name} is stopped"]
  # }
  #
  # utils::extract_tgz {"":
  #   overwrite => true,
  #   owner => $service_name,
  #   group => $service_name
  # }
  #
  # exec {"${service_name} bundle install":
  #   environment => ["ENV=${app_env}"],
  #   command => "/usr/local/bin/ruby2.4/bundle exec rake admin:db:seed",
  #   user => $service_name,
  #   cwd => $root,
  #   require => Utils::Extract_Tgz["${service_name} db:migrate"]
  # }
  #
  #
  # exec {"${service_name} db:seed":
  #   environment => ["ENV=${app_env}"],
  #   command => "/usr/local/bin/ruby2.4/bundle exec rake admin:db:seed",
  #   user => $service_name,
  #   cwd => $root,
  #   require => Utils::Extract_Tgz["${service_name} db:migrate"]
  # }
  #
  # exec {"${service_name} start server in the background":
  #   environment => ["ENV=${app_env}"],
  #   command => "/usr/local/bin/ruby2.4/bundle exec rake admin:server:start",
  #   user => $service_name,
  #   cwd => $server_root,
  #   require => Exec["${service_name} db:migrate"]
  # }

}