require 'rubygems'
require 'bundler/setup'

require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

set :backend, :exec

properties = YAML.load_file('properties.yml')

RSpec.configure do |c|
  c.host  = ENV['TARGET_HOST']
  set_property properties[c.host]
  options = Net::SSH::Config.for(c.host)
  user    = 'vagrant'
  c.ssh   = Net::SSH.start(c.host, user, options)
end