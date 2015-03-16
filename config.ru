$:.unshift(File.expand_path('../lib', __FILE__))
require 'rubygems'
require 'bundler'

Bundler.require

require 'trello_hook_listener'

$stdout.sync = true
logger = Logger.new(STDOUT)
Mongoid.logger = Logger.new($stdout)
Moped.logger = Logger.new($stdout)

use Rack::MethodOverride

run TrelloHookListener

