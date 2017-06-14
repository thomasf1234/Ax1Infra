#Ubuntu ruby script to bootstrap a go-server
require 'rexml/document'
require 'digest/sha1'
require 'fileutils'
require 'securerandom'

class BootstrapGoServer
  PASSWORD_FILE_PATH = "/etc/go/htpasswd"
  CRUISE_CONFIG_PATH = "/etc/go/cruise-config.xml"
  AGENT_AUTO_REGISTER_KEY = '4280ef4d-48b6-42ec-9e0f-65d7dd05fe07'

  def perform
    bootstrap_password_file
    bootstrap_cruise_config
  end

  protected
  def bootstrap_password_file
    if File.exist?(PASSWORD_FILE_PATH)
      puts "Password file #{PASSWORD_FILE_PATH} already exists. Skipping bootstrap_password_file"
    else
      dev_htpasswd_entry = htpasswd_entry("dev", "dev")
      admin_htpasswd_entry = htpasswd_entry("admin", "admin")

      File.open(PASSWORD_FILE_PATH, "w") do |file|
        file.puts(dev_htpasswd_entry)
        file.puts(admin_htpasswd_entry)
      end

      FileUtils.chown('go', 'go', PASSWORD_FILE_PATH)
      File.chmod(0644, PASSWORD_FILE_PATH)
    end
  end

  def bootstrap_cruise_config
    if File.exist?(CRUISE_CONFIG_PATH)
      cruise_config_rexml = REXML::Document.new(File.read(CRUISE_CONFIG_PATH))

      bootstrap_security_element(cruise_config_rexml)
      bootstrap_pipelines_elements(cruise_config_rexml)

      File.open(CRUISE_CONFIG_PATH, "w") do |file|
        cruise_config_rexml.write(file)
      end

      puts "finished bootstrap"
    else
      puts "No cruise-config.xml found at #{CRUISE_CONFIG_PATH}. Skipping bootstrap_cruise_config"
    end
  end

  def bootstrap_security_element(cruise_config_rexml)
    server_element = cruise_config_rexml.get_elements("//server").first

    if server_element.nil?
      puts "No <server> element found in #{CRUISE_CONFIG_PATH}. Exiting"
    else
      server_element.add_attribute('agentAutoRegisterKey', AGENT_AUTO_REGISTER_KEY)

      if server_element.get_elements("//security").empty?
        puts "No <security> element found. Adding a default configuration"
        security_element = build_default_security_element
        server_element.add_element(security_element)
      else
        puts "An existing <security> element found. Skipping bootstrap_cruise_config"
      end
    end
  end

  def bootstrap_pipelines_elements(cruise_config_rexml)
    existing_pipelines_elements = cruise_config_rexml.get_elements("//pipelines")

    if existing_pipelines_elements.empty?
      puts "No <pipelines> element found in #{CRUISE_CONFIG_PATH}. Adding default"
      build_pipelines_elements.reverse.each do |pipelines_element|
        cruise_config_rexml.root.insert_after("//server", pipelines_element)
      end
    else
      puts "An existing <pipelines> element found. Skipping bootstrap_pipelines_element"
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
    auth_config_element.add_attributes({'id' => SecureRandom.uuid, 'pluginId' => 'cd.go.authentication.passwordfile'})

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

  def htpasswd_entry(username, password)
    "#{username}:{SHA}#{Digest::SHA1.base64digest(password)}"
  end

  def build_pipelines_elements
    pipelines_elements_raw = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<cruise>
  <pipelines group="DevelopmentMaster">
    <pipeline name="ax1_utils">
      <environmentvariables>
        <variable name="ENV">
          <value>test</value>
        </variable>
      </environmentvariables>
      <materials>
        <git url="https://github.com/thomasf1234/ax1_utils.git" />
      </materials>
      <stage name="buildTest" cleanWorkingDir="true">
        <jobs>
          <job name="buildTest">
            <tasks>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>install</arg>
                <arg>--clean</arg>
                <arg>--path</arg>
                <arg>vendor/bundle</arg>
              </exec>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>exec</arg>
                <arg>rspec</arg>
                <arg>spec/</arg>
                <runif status="passed" />
              </exec>
            </tasks>
            <resources>
              <resource>builder</resource>
            </resources>
          </job>
        </jobs>
      </stage>
    </pipeline>
    <pipeline name="yugioh_x2">
      <environmentvariables>
        <variable name="ENV">
          <value>test</value>
        </variable>
      </environmentvariables>
      <materials>
        <git url="https://github.com/thomasf1234/yugioh_x2.git" />
      </materials>
      <stage name="buildTest" cleanWorkingDir="true">
        <jobs>
          <job name="buildTest">
            <tasks>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>install</arg>
                <arg>--clean</arg>
                <arg>--path</arg>
                <arg>vendor/bundle</arg>
              </exec>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>exec</arg>
                <arg>rspec</arg>
                <arg>spec/</arg>
                <runif status="passed" />
              </exec>
            </tasks>
            <resources>
              <resource>builder</resource>
            </resources>
          </job>
        </jobs>
      </stage>
    </pipeline>
    <pipeline name="AECCClient">
      <environmentvariables>
        <variable name="ENV">
          <value>test</value>
        </variable>
      </environmentvariables>
      <materials>
        <git url="https://github.com/thomasf1234/AECCClient.git" />
      </materials>
      <stage name="buildTest" cleanWorkingDir="true">
        <jobs>
          <job name="buildTest">
            <tasks>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>install</arg>
                <arg>--clean</arg>
                <arg>--path</arg>
                <arg>vendor/bundle</arg>
              </exec>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>exec</arg>
                <arg>rspec</arg>
                <arg>spec/</arg>
                <runif status="passed" />
              </exec>
            </tasks>
            <resources>
              <resource>builder</resource>
            </resources>
          </job>
        </jobs>
      </stage>
    </pipeline>
  </pipelines>
  <pipelines group="DevelopmentBranches">
    <pipeline name="yugioh_x2-Branch">
      <environmentvariables>
        <variable name="ENV">
          <value>test</value>
        </variable>
      </environmentvariables>
      <materials>
        <git url="https://github.com/thomasf1234/yugioh_x2.git" />
      </materials>
      <stage name="buildTest" cleanWorkingDir="true">
        <jobs>
          <job name="buildTest">
            <tasks>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>install</arg>
                <arg>--clean</arg>
                <arg>--path</arg>
                <arg>vendor/bundle</arg>
              </exec>
              <exec command="/usr/local/bin/ruby2.4/bundle">
                <arg>exec</arg>
                <arg>rspec</arg>
                <arg>spec/</arg>
                <runif status="passed" />
              </exec>
            </tasks>
            <resources>
              <resource>builder</resource>
            </resources>
          </job>
        </jobs>
      </stage>
    </pipeline>
  </pipelines>
</cruise>
EOF

    REXML::Document.new(pipelines_elements_raw).get_elements("//pipelines")
  end
end

BootstrapGoServer.new.perform
