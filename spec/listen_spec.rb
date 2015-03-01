require_relative 'spec_helper'
require 'listen'
require 'base64'
require 'openssl'

describe TrelloHookListener do
	let(:payload_body) {'{"test":"body"}'}
	let(:callback_URL) {'http://localhost/hook?test=yes'}
	let(:trello_key) {"dev_key"}
	
	subject {TrelloHookListener.new!}

	describe '.verify_signature' do
		context 'when signature is not equal' do
			let(:hash) {"1234567890abcdef"}
			it { expect { subject.verify_signature(payload_body, callback_URL, hash, trello_key) }.to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end
		
		context 'when signature is equal' do
			let(:hash) { Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), trello_key, payload_body+callback_URL)) }
			it { expect { subject.verify_signature(payload_body, callback_URL, hash, trello_key) }.not_to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end
	end
end