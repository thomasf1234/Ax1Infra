module SpecHelper
  class VagrantRectifier
    PUPPET_TEST_NAME = 'puppet_test'

    def initialize(terminal)
      @terminal = terminal
    end

    def reset_test_base
      begin
        Ax1Utils::SLogger.instance.debug($log_name, "Destroying #{PUPPET_TEST_NAME} in case running")
        @terminal.log_exec("vagrant destroy --force #{PUPPET_TEST_NAME}", $log_path)

        Ax1Utils::SLogger.instance.debug($log_name, "Starting #{PUPPET_TEST_NAME}")
        @terminal.log_exec("vagrant up --no-provision #{PUPPET_TEST_NAME}", $log_path)
      rescue => e
        Ax1Utils::SLogger.instance.error($log_name, "Failed to reset #{PUPPET_TEST_NAME}")
        Ax1Utils::SLogger.instance.error($log_name, e)
        raise e
      end
    end
  end
end