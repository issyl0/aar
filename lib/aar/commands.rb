module Aar
  class Commands
    def initialize
      construct_command
      run_command
    end

    def construct_command
      @command = {}
      $config_file[$environment].each do |k,v|
        @command[k] = v
      end
    end

    def run_command
      $tokens = `aws \
      --profile=#{@command["profile"]} sts assume-role \
      --role-session-name "$(whoami)-$(date +%d-%m-%y_%H-%M)" \
      --role-arn "arn:aws:iam::#{@command["role_account_id"]}:role/#{@command["role"]}" \
      --serial-number "arn:aws:iam::#{@command["mfa_account_id"]}:mfa/#{@command["username"]}" \
      --token-code #{$mfa_code}`
    end
  end
end
