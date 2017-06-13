module Puppet::Parser::Functions
  newfunction(:utils_file_exists, :type => :rvalue, :doc => <<-EOS
Returns true if file exist
  EOS
  ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "utils_file_exists(): Wrong number of arguments given (#{args.size} for 1)")
    end

    path = args[0]

    if !path.kind_of?(String)
      raise(Puppet::ParseError, "utils_file_exists(): Illegal type, path must extend String. #{path.class} given")
    end

    File.exists?(path)
  end
end
