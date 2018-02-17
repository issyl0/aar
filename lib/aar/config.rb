module Aar
  class Config
    if ENV['AAR_CONFIG_FILE']
      $config_file = YAML.load_file(File.expand_path(ENV['AAR_CONFIG_FILE']))
    else
      puts "Error: Specify a config file as an envvar: AAR_CONFIG_FILE."
      exit
    end
  end
end
