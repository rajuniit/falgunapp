require 'ostruct'

config_file = Rails.root + "config/falgun.yml"

if !File.exist?(config_file)
  raise StandardError, "Config was not found"
end

options = YAML.load_file(config_file)

if !options[Rails.env]
  raise "'#{Rails.env}' was not found in #{config_file}"
end

App_Config = OpenStruct.new(options[Rails.env])
