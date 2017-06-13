class git_config(
  $user,
  $userhome
) {
  $file = utils_file_join($userhome, ".gitconfig")
  file {
    $file:
      owner   => $user,
      group   => $user,
      mode    => '644',
      source => 'puppet:///modules/git_config/.gitconfig'
  }
}