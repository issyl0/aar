module Aar
  class Cli
    def initialize(args)
      args << '-h' if ARGV.empty?
      @options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: bundle exec aar -e environment -o output -m mfa_code"

        opts.on('-e ENVIRONMENT', '--environment=ENVIRONMENT', 'The environment you are assuming the role for.') { |v| @options[:environment] = v }
        opts.on('-o OUTPUT', '--output=OUTPUT', 'How to output the tokens: print them to stdout, or export them into the shell.') { |v| @options[:output] = v }
        opts.on('-m CODE', '--mfa-code=CODE', 'The MFA code of your user account.') { |v| @options[:mfa_code] = v }

        opts.on_tail("-h", "--help", "Show this help message.") do
          puts opts
          exit 1
        end
      end.parse!

      $output = @options[:output]
      $environment = @options[:environment]
      $mfa_code = @options[:mfa_code]
    end
  end
end
