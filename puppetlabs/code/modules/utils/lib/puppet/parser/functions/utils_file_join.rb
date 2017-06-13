module Puppet::Parser::Functions
  newfunction(:utils_file_join, :type => :rvalue, :doc => <<-EOS
Returns the last component of the filename given in file_name, which must be formed using forward slashes
(“/”) regardless of the separator used on the local file system. If suffix is given and present at the end of
file_name, it is removed.
  EOS
  ) do |args|

    if args.size != 2
      raise(Puppet::ParseError, "utils_file_join(): Wrong number of arguments given (#{args.size} for 2)")
    end

    path1 = args[0]
    path2 = args[1]

    if !path1.kind_of?(String) || !path1.kind_of?(String)
      raise(Puppet::ParseError, "utils_file_join(): Illegal type, paths must extend String.")
    end

    File.join(path1, path2)
  end
end
