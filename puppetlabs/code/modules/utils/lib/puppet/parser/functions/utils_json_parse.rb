require 'json'

module Puppet::Parser::Functions
  newfunction(:utils_json_parse, :type => :rvalue, :doc => <<-EOS
parses json file
  EOS
  ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "utils_json_parse(): Wrong number of arguments given (#{args.size} for 1)")
    end

    path = args[0]

    if !path.kind_of?(String)
      raise(Puppet::ParseError, "utils_json_parse(): Illegal type, path must extend String. #{path.class} given")
    end

    if File.exists?(path)
      json = File.read(path).strip
      JSON.parse(json)
    else
      raise(Puppet::ParseError, "utils_json_parse(): File not found at #{path}")
    end
  end
end
