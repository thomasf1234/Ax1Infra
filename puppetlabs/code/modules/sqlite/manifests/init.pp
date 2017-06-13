class sqlite {
  Package { ensure => latest }
  
  package {'sqlite3': }
  package {'libsqlite3-dev': }
}