require 'yaml'
require 'optparse'

require_relative 'aar/version'
require_relative 'aar/cli'

Aar::Cli

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

    def config
      if ENV['AAR_CONFIG_FILE']
        @config_file = YAML.load_file(File.expand_path(ENV['AAR_CONFIG_FILE']))
      else
        puts "Error: Specify a config file as an envvar: AAR_CONFIG_FILE."
        exit
      end
    end

    def construct_command
      @command = {}
      @config_file[@environment].each do |k,v|
        @command[k] = v
      end
    end

    def run_command
      @tokens = `aws \
      --profile=#{@command["profile"]} sts assume-role \
      --role-session-name "$(whoami)-$(date +%d-%m-%y_%H-%M)" \
      --role-arn "arn:aws:iam::#{@command["role_account_id"]}:role/#{@command["role"]}" \
      --serial-number "arn:aws:iam::#{@command["mfa_account_id"]}:mfa/#{@command["username"]}" \
      --token-code #{@mfa_code}`
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
