module Puppet::Parser::Functions
  newfunction(:utils_basename, :type => :rvalue, :doc => <<-EOS
Returns the last component of the filename given in file_name, which must be formed using forward slashes
(“/”) regardless of the separator used on the local file system. If suffix is given and present at the end of
file_name, it is removed.
  EOS
  ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "basename(): Wrong number of arguments given (#{args.size} for 1)")
    end

    path = args[0]

    if !path.kind_of?(String)
      raise(Puppet::ParseError, "basename(): Illegal type, path must extend String. #{path.class} given")
    end

    File.basename(path)
  end
end
