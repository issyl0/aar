require 'json'
require 'optparse'
require 'yaml'

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
