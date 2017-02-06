#! /usr/bin/env ruby
require 'OpenSSL'
require 'typhoeus'
require 'json'
require "docopt"
require 'yaml'

$VERBOSE=true
command_name = File.basename(__FILE__)

APP_KEY=ENV["TRELLO_APP_KEY"]
TOKEN=ENV["TRELLO_TOKEN"]
SECRET=ENV["TRELLO_SECRET"]

doc = <<DOCOPT
#{command_name} - trello webhook util

Usage:
  #{command_name} add-hook <model> <callbackURL> [<description>]
  #{command_name} delete-hook <hook-id>
  #{command_name} get-hook <hook-id>
  #{command_name} list-hooks
  #{command_name} delete-hooks
  #{command_name} send <url> <payload>
  #{command_name} (-h | --help) (--version)

Options:
  -h, --help        show this help message and exit
  --version         show version and exit

Description:
  A helper to work with trello webhooks.

DOCOPT

begin
	opt = Docopt::docopt(doc, version: '0.0.1')			
rescue Docopt::Exit => e
	puts e.message
end

def get_saved_webhooks
	webhooks = []
	webhooks_file = Dir.home + '/.trello_hooks.yaml'
	if File.exist?(webhooks_file)
		webhooks = YAML::load(File.open(webhooks_file))
	end
	webhooks
end

def update_hook(webhook_id, type)
	webhooks = get_saved_webhooks
	case type
	when :add
		webhooks.push webhook_id
	when :delete
		webhooks.delete webhook_id
	end

	webhooks_file = Dir.home + '/.trello_hooks.yaml'
	File.open(webhooks_file, 'w') { |file| 
		file.write(webhooks.to_yaml) 
	}
end

def add_hook(id_model, callbackURL, description)
	payload_body = {
	  description: description.nil? ? "a webhook" : description,
	  callbackURL: callbackURL,
	  idModel: id_model
	}

	request = Typhoeus::Request.new(
	  "https://trello.com/1/tokens/#{TOKEN}/webhooks/?key=#{APP_KEY}",
	  method: :post,
	  body: payload_body,
	)

	response = request.run
	puts response.body
	if response.code == 200
		body = JSON.parse(response.body)
		update_hook(body["id"], :add)
	end
end

def delete_hook(webhook_id)
	#DELETE https://trello.com/1/webhooks/[WEBHOOK_ID]?key=[APPLICATION_KEY]&token=[USER_TOKEN]
	request = Typhoeus::Request.new(
		"https://trello.com/1/tokens/#{TOKEN}/webhooks/#{webhook_id}?key=#{APP_KEY}",
		method: :delete
	)
	response = request.run
	if response.code == 200
		update_hook(webhook_id, :delete)
	end
end

def get_hook(webhook_id)
	url = "https://trello.com/1/tokens/#{TOKEN}/webhooks/#{webhook_id}?key=#{APP_KEY}"
	request = Typhoeus::Request.new(
		url,
		method: :get
	)

	response = request.run
	puts response.body
end

def list_hooks
	get_saved_webhooks.each {|id|
		get_hook id
	}
end

def delete_hooks
	get_saved_webhooks.each {|id|
		delete_hook id
	}
end

def base64Digest subject
	puts subject
	require 'base64'
	require 'openssl'
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), SECRET, subject)
end

def send_payload(url, payload)
	payload_body = File.open(payload).read
	request = Typhoeus::Request.new(
	  url,
	  method: :post,
	  body: payload_body,
	  headers: { 'x-trello-webhook' => base64Digest(payload_body+url), 'Content-Type' => 'text/json' }
	)

	response = request.run
	puts response.code
	puts response.body
end

if opt["add-hook"]
	add_hook opt["<model>"], opt["<callbackURL>"], opt["<description>"]
elsif opt["delete-hook"]
	delete_hook opt["<hook-id>"]
elsif opt["get-hook"]
	get_hook opt["<hook-id>"]
elsif opt["list-hooks"]
	list_hooks
elsif opt["delete-hooks"]
	delete_hooks
elsif opt["send"]
	send_payload opt["<url>"], opt["<payload>"]
end
