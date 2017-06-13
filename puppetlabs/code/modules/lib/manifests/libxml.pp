class lib::libxml {
  package {"libxml2-dev":
    ensure => latest
  }
  
  package {"libxslt1-dev":
    ensure => latest
  }
}