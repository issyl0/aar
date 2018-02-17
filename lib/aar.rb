require 'json'
require 'yaml'
require 'optparse'

require_relative 'aar/version'
require_relative 'aar/cli'
require_relative 'aar/config'
require_relative 'aar/commands'
require_relative 'aar/access_keys'
require_relative 'aar/token_expiry'

Aar::Cli
Aar::Config
Aar::Commands.new
Aar::AccessKeys.new
Aar::TokenExpiry.print_token_expiry

module Aar
  class AssumeRole

    def call
      config
      construct_command
      run_command
      if @output == "export" || @output.nil?
        export_access_keys
      elsif @output == "print"
        print_access_keys
      end
      print_token_expiry
    end
  end
end
