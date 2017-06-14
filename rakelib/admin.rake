require 'logger'

namespace :admin do
  #rake admin:provision[tst-host01,env]
  desc "provision host"
  task :provision, [:host, :env] do |t, args|
    host = args[:host].strip
    env = args[:env].strip

    begin
      Ax1Utils::SLogger.instance.clear($log_name)

      terminal = Ax1Infra::Terminal.new
      Ax1Utils::SLogger.instance.info($log_name, "Provisioning host: #{host}, environment: #{env}")
      remote_provisioner = Ax1Infra::RemoteProvisioner.new(terminal, host, env)

      Ax1Utils::SLogger.instance.info($log_name, "Deploy/Run bootstrap")
      remote_provisioner.bootstrap

      Ax1Utils::SLogger.instance.info($log_name, "Deploying puppet")
      remote_provisioner.deploy_puppet

      Ax1Utils::SLogger.instance.info($log_name, "Running puppet")
      remote_provisioner.run_puppet

      Ax1Utils::SLogger.instance.info($log_name, "Puppet provisioning finished")
    end
  end
end