require 'sinatra'
require 'json'
require 'pp'
require 'erb'
require 'yaml'
require 'rubygems'
require 'active_support/inflector'
require 'set'
require 'version'

class TrelloHookListener < Sinatra::Base

  ############################################################
  ## Trello Webhook registration
  ############################################################

  # returns the registration page
  #
  get '/register' do
    erb :register
  end

  get '/version' do
    "version: #{TrelloWebhookListener::VERSION}"
  end

  ############################################################
  ## Trello Webhook
  ############################################################

  get '/hook' do
    return 200
  end

  post '/hook' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
    
    if params[:payload]
      push = JSON.parse(params[:payload])
    else
      push = JSON.parse payload_body
    end

    unless push.nil?
      puts push.to_json
    end

    return 200
  end

  def verify_signature(payload_body)
    return true
    #signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    #return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

end
