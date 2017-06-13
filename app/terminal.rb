module Ax1Infra
  class Terminal < Ax1Utils::Terminal
    protected
    def before_exec(command)
      Ax1Utils::SLogger.instance.info($log_name, "Executing command: #{command}")
    end

    def after_exec(command)
      Ax1Utils::SLogger.instance.success($log_name, "Finished executing command: #{command}")
    end

    def on_exception(command, exception)
      raise exception
    end
  end
end