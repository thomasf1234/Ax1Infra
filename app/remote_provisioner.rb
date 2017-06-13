module Ax1Infra
  class RemoteProvisioner
    def initialize(host, environment, port=22)
      @host = host
      @port = port
      @environment = environment
      @terminal = Ax1Utils::Terminal.new
    end

    def bootstrap
      local_bootstrap_path = "scripts/bootstrap.bash"
      remote_bootstrap_path = "/tmp/bootstrap.bash"
      @terminal.exec(@terminal.scp_command("deploy", @host, @port, local_bootstrap_path, remote_bootstrap_path, ssh_options))
      Ax1Utils::SLogger.instance.info($log_name, "Running Bootstrap: #{remote_bootstrap_path}")
      @terminal.log_exec(@terminal.ssh_command("deploy", @host, @port, "sudo bash #{remote_bootstrap_path}", ssh_options), $log_path)
    end

    def deploy_puppet
      @terminal.log_exec(@terminal.ssh_command("deploy", @host, @port, "sudo rm -rf /etc/puppetlabs/*", ssh_options), $log_path)
      @terminal.exec("tar -zc -f puppetlabs-release.tgz -C puppetlabs .")
      @terminal.exec(@terminal.scp_command("deploy", @host, @port, "puppetlabs-release.tgz", "/tmp/puppetlabs-release.tgz", ssh_options))
      @terminal.log_exec(@terminal.ssh_command("deploy", @host, @port, "mkdir -p /etc/puppetlabs && sudo tar -mxz -f /tmp/puppetlabs-release.tgz -C /etc/puppetlabs", ssh_options), $log_path)
    end

    def run_puppet
      remote_manifest_path = "/etc/puppetlabs/code/environments/#{@environment}/manifests"

      Ax1Utils::SLogger.instance.debug($log_name, "Running Manifest: #{remote_manifest_path}")
      begin
        @terminal.log_exec(@terminal.ssh_command("deploy", @host, @port, "sudo /opt/puppetlabs/bin/puppet apply --debug --verbose --environment #{@environment} --detailed-exitcodes #{remote_manifest_path}", ssh_options), $log_path)
      rescue Ax1Utils::ShellException => se
        unless se.exitstatus == PuppetExitStatus::RUN_SUCCEEDED_SOME_RESOURCES_CHANGED
          raise se
        end
      end
    end

    private
    def ssh_options
      {"IdentityFile" => "~/.ssh/deploy.id_rsa"}
    end
  end
end