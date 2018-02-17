module Aar
  class AccessKeys
    def initialize
      parse_tokens
      if $output == nil || $output == "export"
        export_access_keys
      elsif $output == "print"
        print_access_keys
      end
    end

    def parse_tokens
      @access_key = JSON.parse($tokens)['Credentials']['AccessKeyId']
      @secret_key = JSON.parse($tokens)['Credentials']['SecretAccessKey']
      @session_token = JSON.parse($tokens)['Credentials']['SessionToken']
      $session_token_expiry = DateTime.parse(JSON.parse($tokens)['Credentials']['Expiration']).strftime('%H:%M:%S')
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
  end
end
