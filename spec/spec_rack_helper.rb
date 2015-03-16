# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require 'trello_hook_listener'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure { |c| c.include RSpecMixin }
