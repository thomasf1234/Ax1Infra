ENV['ENV'] ||= 'test'
ENV['TEST_RUNNER'] ||= 'vagrant'

Bundler.require(:default, ENV['ENV'])
require_relative '../application'
require_relative 'vagrant_rectifier'
require_relative 'remote_inspector'

Dir["./spec/support/shared_examples/**/*.rb"].each {|file| require file}

RSpec.configure do |config|
  config.color= true
  config.order= :rand
  config.default_formatter = 'doc'
  config.profile_examples = 10
  config.warnings = true
  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!

  config.before(:suite) do
    Ax1Utils::SLogger.instance.clear($log_name)
    case ENV['TEST_RUNNER']
      when 'vagrant'
        pupet_test_ip = '192.168.20.23'
        $terminal = Ax1Infra::Terminal.new
        $provisioner = Ax1Infra::RemoteProvisioner.new($terminal, pupet_test_ip, ENV['ENV'])
        $inspector = SpecHelper::RemoteInspector.new($terminal, pupet_test_ip, ENV['ENV'])
        $rectifier = SpecHelper::VagrantRectifier.new($terminal)
      else
        raise "Unknown TEST_RUNNER '#{ENV['TEST_RUNNER']}' Exiting..."
    end
  end

  config.before(:all) do
    Ax1Utils::SLogger.instance.debug($log_name, "resetting puppet_test and re-deployment of puppet")
    $rectifier.reset_test_base
    $provisioner.deploy_puppet
  end
end
