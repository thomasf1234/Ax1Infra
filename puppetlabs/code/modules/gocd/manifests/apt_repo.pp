class gocd::apt_repo {
  utils::apt_repo {"gocd":
    list_source => "puppet:///modules/gocd/etc/apt/sources.list.d/gocd.list",
    key_source => "https://download.gocd.io/GOCD-GPG-KEY.asc",
    key_id => "GOCD-GPG-KEY"
  }
}
