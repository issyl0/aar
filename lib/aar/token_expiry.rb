module Aar
  class TokenExpiry
    def print_token_expiry
      puts "export AWS_SESSION_TOKEN_EXPIRY=#{$session_token_expiry}"
      puts "Your tokens have been #{$output}ed and will expire at #{$session_token_expiry}."
    end
  end
end
