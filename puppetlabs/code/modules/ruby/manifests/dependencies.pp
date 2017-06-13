class ruby::dependencies {
  include lib::build
  include lib::python_software_properties
  include lib::libpq
  include lib::libcurl
  include lib::libffi
  include lib::libreadline
  include lib::libxml
  include lib::libyaml
  include lib::nodejs
  include openssl
  include lib::libssldev
  include lib::zlib
}