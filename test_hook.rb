#! /usr/bin/env ruby
require 'OpenSSL'
require 'typhoeus'
require 'json'

$VERBOSE=true

payload_body = File.read(ARGV[0])

signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)

request = Typhoeus::Request.new(
  "http://localhost:5555/payload",
  method: :post,
  body: payload_body,
  headers: { ContentType: "application/json", X_Hub_Signature: signature }
).run
