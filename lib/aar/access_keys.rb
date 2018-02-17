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
      begin
        @access_key = JSON.parse($tokens)['Credentials']['AccessKeyId']
        @secret_key = JSON.parse($tokens)['Credentials']['SecretAccessKey']
        @session_token = JSON.parse($tokens)['Credentials']['SessionToken']
        $session_token_expiry = DateTime.parse(JSON.parse($tokens)['Credentials']['Expiration']).strftime('%H.%M.%S')
      rescue JSON::ParserError
        exit 1
      end
    end

    def export_access_keys
      puts "export AWS_SESSION_TOKEN=#{@access_key}"
      puts "export AWS_SECRET_ACCESS_KEY=#{@secret_key}"
      puts "export AWS_SESSION_TOKEN=#{@session_token}"
    end

    def print_access_keys
      puts "echo 'AWS_SESSION_TOKEN: #{@access_key}\n'"
      puts "echo 'AWS_SECRET_ACCESS_KEY: #{@secret_key}\n'"
      puts "echo 'AWS_SESSION_TOKEN: #{@session_token}\n'"
    end
  end
end
