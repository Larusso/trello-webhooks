require_relative 'spec_helper'
require 'listen'
require 'base64'
require 'openssl'

describe TrelloHookListener do
	let(:payload_body) {'{"test":"body"}'}
	let(:callback_URL) {'http://localhost/hook?test=yes'}
	let(:trello_key) {"dev_key"}
	
	subject {TrelloHookListener.new!}

	before :each do
		ENV["TRELLO_SECRET"] = trello_key
	end

	describe '.verify_signature' do
		context 'when signature is not equal' do
			let(:hash) {"1234567890abcdef"}
			it { expect { subject.verify_signature(payload_body, callback_URL, hash) }.to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end
		
		context 'when signature is equal' do
			let(:hash) { OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), trello_key, payload_body+callback_URL) }
			it { expect { subject.verify_signature(payload_body, callback_URL, hash) }.not_to throw_symbol(:halt, 500) }
		end
	end
end