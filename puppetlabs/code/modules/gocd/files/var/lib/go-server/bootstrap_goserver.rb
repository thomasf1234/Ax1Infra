#Ubuntu ruby script to bootstrap a go-server
require 'rexml/document'
require 'digest/sha1'

class BootstrapGoServer
  PASSWORD_FILE_PATH = "/var/lib/go-server/htpasswd"
  CRUISE_CONFIG_PATH = "/etc/go/cruise-config.xml"

  def perform
    if File.exist?(CRUISE_CONFIG_PATH)
      existing_cruise_config = REXML::Document.new(File.read(CRUISE_CONFIG_PATH))
      server_element = existing_cruise_config.get_elements("//server").first

      if server_element.nil?
        puts "No <server> element found in #{CRUISE_CONFIG_PATH}. Exiting"
      else
        if server_element.get_elements("//security").empty?
          puts "No <security> element found. Adding a default configuration"
          security_element = build_default_security_element
          server_element.add_element(security_element)

          File.open(CRUISE_CONFIG_PATH,"w") do |file|
            existing_cruise_config.write(file)
          end
        else
          puts "An existing <security> element found. Exiting"
        end
      end
    else
      puts "No cruise-config.xml found at #{CRUISE_CONFIG_PATH}. Exiting..."
    end
  end

  def build_default_security_element
    rexml = REXML::Element.new('security')

    if use_auth_plugin?
      rexml.add_element(auth_configs_element)
    else
      rexml.add_element(password_file_element)
    end

    rexml.add_element(admins_element(["admin"]))
    rexml
  end

  def print(rexml)
    formatter = REXML::Formatters::Pretty.new(2)
    formatter.compact = true
    formatter.write(rexml, $stdout)
  end

  #GoCD introduced this at v17.5.0
  def auth_configs_element
    base_element = REXML::Element.new('authConfigs')
    auth_config_element = REXML::Element.new('authConfig')
    auth_config_element.add_attributes({'id' => 'auth-config-id', 'pluginId' => 'cd.go.authentication.passwordfile'})

    property_element = REXML::Element.new('property')

    key_element = REXML::Element.new('key')
    key_element.add_text('PasswordFilePath')
    property_element.add_element(key_element)

    value_element = REXML::Element.new('value')
    value_element.add_text(PASSWORD_FILE_PATH)
    property_element.add_element(value_element)

    auth_config_element.add_element(property_element)
    base_element.add_element(auth_config_element)
    base_element
  end

  #GoCD deprecated this at v17.5.0
  def password_file_element
    base_element = REXML::Element.new('passwordFile')
    base_element.add_attributes('path' => PASSWORD_FILE_PATH)
    base_element
  end

  def admins_element(admins)
    base_element = REXML::Element.new('admins')

    admins.each do |admin|
      user_element = REXML::Element.new('user')
      user_element.add_text(admin)
      base_element.add_element(user_element)
    end

    base_element
  end

  def use_auth_plugin?
    current_version > Gem::Version.new("17.4.0")
  end

  def current_version
    raw_version = `dpkg -s go-server`.match(/Version:.*/).to_s.split(':').last.strip
    Gem::Version.new(raw_version)
  end
end

BootstrapGoServer.new.perform
