module SpecHelper
  class RemoteInspector
    def initialize(terminal, host, environment, port=22)
      @terminal = terminal
      @host = host
      @port = port
      @environment = environment
    end

    def ssh(command)
      @terminal.exec(@terminal.ssh_command("deploy", @host, @port, command, ssh_options))
    end

    def package_installed?(package)
      begin
        ssh("dpkg -s #{package}").match(/Status:.*/).to_s.split(':').last.strip == "install ok installed"
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def package_available?(package)
      ssh("apt-cache policy #{package}").match(/Unable to locate package/).nil?
    end

    def gem2_4_installed?(gem_name, version=nil)
      begin
        command = "/usr/bin/gem2.4 list -i ^#{gem_name}$"
        command += " -v #{version}" unless version.nil?
        ssh(command).strip == "true"
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def latest_gem2_4_version?(gem_name)
      gem2_4_installed?(gem_name, latest_gem_version(gem_name))
    end

    def path_exists?(remote_path)
      test(remote_path, "-e")
    end

    def file_exists?(remote_path)
      test(remote_path, "-f")
    end

    def dir_exists?(remote_path)
      test(remote_path, "-d")
    end

    def link_exists?(remote_path)
      test(remote_path, "-L")
    end

    def test(remote_path, flag)
      begin
        ssh("sudo test #{flag} #{remote_path}")
        true
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def user_exists?(user)
      begin
        ssh("sudo cat /etc/passwd | grep -- '^#{user}'")
        true
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def readlines(remote_path)
      ssh("sudo cat #{remote_path}").strip.split
    end

    def compare(local_file_path, remote_file_path)
      remote_lines = readlines(remote_file_path)
      local_lines = File.read(local_file_path).strip.split
      remote_lines == local_lines
    end


    def file_info(remote_path)
      if path_exists?(remote_path)
        hash = {}

        hash[:chmod] = ssh("sudo stat -c %A #{remote_path}").strip
        hash[:owner] = ssh("sudo stat -c %U #{remote_path}").strip
        hash[:group] = ssh("sudo stat -c %G #{remote_path}").strip
        hash[:bytes] = ssh("sudo stat -c %s #{remote_path}").strip

        hash
      else
        raise Errno::ENOENT
      end
    end

    def apt_key_exist?(filename)
      begin
        ssh("apt-key list | grep -w #{filename}")
        true
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def get_environment_variable(name)
      ssh("echo \\$#{name}").strip
    end

    def netstat_port_listening?(port)
      begin
        ssh("netstat -pan | grep LISTEN | grep -- :#{port}")
        true
      rescue Ax1Utils::ShellException => se
        if se.exitstatus == 1
          false
        else
          raise se
        end
      end
    end

    def go_agent_running?(name)
      begin
        ssh("ps aux | grep /usr/share/#{name}/agent-bootstrapper.jar | grep -v grep")
        true
      rescue Ax1Utils::ShellException => se
        false
      end
    end

    private
    def ssh_options
      {"IdentityFile" => "~/.ssh/deploy.id_rsa"}
    end
  end
end
