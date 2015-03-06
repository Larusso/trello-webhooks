require 'sinatra'
require 'json'
require 'pp'
require 'erb'
require 'yaml'
require 'rubygems'
require 'active_support/inflector'
require 'set'
require 'version'
require 'hooks'
require 'client'
require 'bundler/setup'
require 'base64'
require 'openssl'

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

  head '/hook' do
    return 200
  end

  post '/hook' do
    request.body.rewind
    payload_body = request.body.read

    verify_signature payload_body, request.url, request.env['HTTP_X_TRELLO_WEBHOOK'], ENV['TRELLO_SECRET']
    
    if params[:payload]
      puts params[:payload]
      push = JSON.parse(params[:payload])
    else
      puts payload_body
      push = JSON.parse payload_body
    end
    
    return 200
  end

  ############################################################
  ## auto assign
  ############################################################

  head '/auto-assign' do
    return 200
  end

  post '/auto-assign' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature payload_body, request.url, request.env['HTTP_X_TRELLO_WEBHOOK'], ENV['TRELLO_SECRET']
    
    if params[:payload]
      push = JSON.parse(params[:payload])
    else
      push = JSON.parse payload_body
    end

    Hooks::AutoAssign.new(push['action']).execute
  end

  ############################################################
  ## auto version
  ############################################################

  head '/auto-version' do
    return 200
  end

  post '/auto-version' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature payload_body, request.url, request.env['HTTP_X_TRELLO_WEBHOOK'], ENV['TRELLO_SECRET']
    
    if params[:payload]
      push = JSON.parse(params[:payload])
    else
      push = JSON.parse payload_body
    end

    Hooks::AutoVersion.new(push['action']).execute
  end

  def verify_signature payload_body, callbackURL, hash, secret
    content = payload_body + callbackURL

    base64_digest = lambda {|s, times=1|
      digest = Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, s))
      digest = base64_digest.call digest, times -1 unless times == 1
      digest
    }

    double_hash = base64_digest.call content, 2
    header_hash = base64_digest.call hash

    puts "Signatures didn't match!" unless Rack::Utils.secure_compare(header_hash, double_hash)
    return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(header_hash, double_hash)
  end
end
