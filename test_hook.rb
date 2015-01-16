#! /usr/bin/env ruby
require 'OpenSSL'
require 'typhoeus'
require 'json'

$VERBOSE=true

payload_body = {
  description: "Jelly Splash Board Hook",
  callbackURL: "https://trello-webhook-listener.herokuapp.com/hook",
  idModel: "53d77b7e8b272ed7c843a945",
}

request = Typhoeus::Request.new(
  "https://trello.com/1/tokens/eee16206196ee309bfcdb3d5e92d0e61b1dbf43eeecbbab4c49c980af997199b/webhooks/?key=15fa67cfb207041016bdd1c3d835efd4",
  method: :post,
  body: payload_body,
)

response = request.run
puts response.code
puts response.total_time
puts response.headers
puts response.body