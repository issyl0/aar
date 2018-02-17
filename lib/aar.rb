require 'json'
require 'yaml'
require 'optparse'

require_relative 'aar/version'
require_relative 'aar/cli'
require_relative 'aar/config'
require_relative 'aar/commands'
require_relative 'aar/access_keys'

Aar::Cli
Aar::Config
Aar::Commands.new
Aar::AccessKeys.new

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

    def print_token_expiry
      puts "export AWS_SESSION_TOKEN_EXPIRY=#{@session_token_expiry}"
      puts "Your tokens have been #{@output}ed and will expire at #{@session_token_expiry}."
    end
  end
end
