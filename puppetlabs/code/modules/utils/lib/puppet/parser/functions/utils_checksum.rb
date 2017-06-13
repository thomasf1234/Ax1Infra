require 'digest'

module Puppet::Parser::Functions
  newfunction(:utils_checksum, :type => :rvalue, :doc => <<-EOS
Generates a checksum from file_path or string using the passed checksum_algorithm
  EOS
  ) do |args|
    SHA256 = 'SHA-256'
    MD5 = 'MD5'
    VALID_CHECKSUM_ALGORITHMS = [SHA256, MD5]

    if args.size != 2
      raise(Puppet::ParseError, "utils_checksum(): Wrong number of arguments given (#{args.size} for 2)")
    end

    source = args[0]
    if !source.kind_of?(String)
      raise(Puppet::ParseError, "utils_checksum(): Illegal type, source must extend String. #{source.class} given")
    end

    checksum_algorithm = args[1]
    if !VALID_CHECKSUM_ALGORITHMS.include?(checksum_algorithm)
      raise(Puppet::ParseError, "utils_checksum(): Illegal type, valid checksum_algorithm values are [#{VALID_CHECKSUM_ALGORITHMS.join(', ')}]. #{checksum_algorithm} given")
    end

    source_content = nil
    if File.exists?(source)
      source_content = File.read(source)
    else
      source_content = source
    end

    checksum = nil
    case checksum_algorithm
      when SHA256
        checksum = Digest::SHA256.hexdigest(source_content)
      when MD5
        checksum = Digest::MD5.hexdigest(source_content)
      else
        raise(Puppet::ParseError, "utils_checksum(): Unknown checksum_algorithm. This should have been caught earlier. #{checksum_algorithm} given")
    end

    checksum
  end
end
