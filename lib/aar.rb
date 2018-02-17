require 'yaml'
require 'optparse'

require_relative 'aar/version'
require_relative 'aar/cli'
require_relative 'aar/config'
require_relative 'aar/commands'

Aar::Cli
Aar::Config
Aar::Commands.new

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

    def parse_tokens
      @access_key = JSON.parse(@tokens)['Credentials']['AccessKeyId']
      @secret_key = JSON.parse(@tokens)['Credentials']['SecretKeyId']
      @session_token = JSON.parse(@tokens)['Credentials']['SessionToken']
      @session_token_expiry = DateTime.parse(JSON.parse(@tokens)['Credentials']['Expiration']).strftime('%H:%M:%S')
    end

    def export_access_keys
      puts "bash -c export AWS_SESSION_TOKEN=#{@access_key}"
      puts "bash -c export AWS_SECRET_ACCESS_KEY=#{@secret_key}"
      puts "bash -c export AWS_SESSION_TOKEN=#{@session_token}"
    end

    def print_access_keys
      access_keys = export_access_keys
      access_keys.gsub!("bash -c export ", "")
      access_keys.gsub!("=",": ")
      access_keys
    end

    def print_token_expiry
      puts "export AWS_SESSION_TOKEN_EXPIRY=#{@session_token_expiry}"
      puts "Your tokens have been #{@output}ed and will expire at #{@session_token_expiry}."
    end
  end
end
