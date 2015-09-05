#!/usr/bin/ruby
require 'yaml'
require 'securerandom'

filename = '/puppet-dashboard/config/settings.yml'
gemfile = '/puppet-dashboard/Gemfile'

yaml = YAML.load_file filename

unless yaml.has_key? 'secret_token'
  yaml['secret_token'] = SecureRandom.hex 64
end

File.open filename, 'w+' do |f|
  f.write yaml.to_yaml
end

# Add Unicorn to the Gemfile
File.open gemfile, 'a' do |f|
  f.write 'gem \'unicorn\''
end
