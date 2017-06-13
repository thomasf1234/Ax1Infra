module Puppet::Parser::Functions
  newfunction(:utils_downcase, :type => :rvalue, :doc => <<-EOS
ruby downcase call
  EOS
  ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "utils_downcase(): Wrong number of arguments given (#{args.size} for 1)")
    end

    string = args[0]

    if !string.kind_of?(String)
      raise(Puppet::ParseError, "utils_downcase(): Illegal type, argument must extend String.")
    end

    string.downcase
  end
end
