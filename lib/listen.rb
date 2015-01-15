require 'sinatra'
require 'json'
require 'client'
require 'comment_formatter'
require 'message_parser'
require 'users'
require 'trello_card_commits'
require 'pp'
require 'erb'
require 'yaml'
require 'rubygems'
require 'active_support/inflector'
require 'set'
require 'mongoid'
require 'webhooker'

class TrelloWebhookListener < Sinatra::Base

  ############################################################
  ## Trello Webhook registration
  ############################################################

  # returns the registration page
  #
  get '/register' do
    erb :register
  end

  ############################################################
  ## Trello Webhook
  ############################################################

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
      puts push
    end

    return 200
  end

  def verify_signature(payload_body)
    return true
    #signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    #return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

end

