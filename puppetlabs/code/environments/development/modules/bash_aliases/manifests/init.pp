class bash_aliases(
  $user,
  $userhome
) {
  $file = utils_file_join($userhome, ".bash_aliases")
  file {
    $file:
      owner   => $user,
      group   => $user,
      mode    => '644',
      source => 'puppet:///modules/bash_aliases/.bash_aliases'
  }
}