ENV['ENV'] ||= 'development'
Bundler.require(:default, ENV['ENV'])
$log_name = ENV['ENV']
$log_path = Ax1Utils::SLogger.instance.file_path($log_name)
Dir["app/**/*.rb"].each { |file| require_relative file }
