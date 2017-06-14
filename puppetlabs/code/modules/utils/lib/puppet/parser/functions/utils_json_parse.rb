require 'json'

module Puppet::Parser::Functions
  newfunction(:utils_json_parse, :type => :rvalue, :doc => <<-EOS
parses json file
  EOS
  ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "utils_json_parse(): Wrong number of arguments given (#{args.size} for 1)")
    end

    json = args[0]

    if !json.kind_of?(String)
      raise(Puppet::ParseError, "utils_json_parse(): Illegal type, path must extend String. #{path.class} given")
    end

    JSON.parse(json.strip)
  end
end
