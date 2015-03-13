# encoding: utf-8

require_relative 'spec_helper'
require_relative 'spec_rack_helper'
require 'listen'
require 'base64'
require 'openssl'

describe TrelloHookListener do
	let(:payload_body) {'{"test":"body"}'}
	let(:callback_URL) {'http://localhost/hook?test=yes'}
	let(:trello_key) {"dev_key"}
	
	subject {TrelloHookListener.new!}

	describe "/convert_check_item_to_sub_task" do

		context "when using method head" do
			let!(:end_point) { head "/convert_check_item_to_sub_task" }
			it { expect(last_response).to be_ok }
		end
	end

	describe "head /hook/:name" do
		
		it "halts with 500 for an unknown hook" do
			head "/hook/anyhook"
			expect(last_response).not_to be_ok
		end

		it "response is ok for a known hook" do
			head "/hook/auto_version"
			expect(last_response).to be_ok
		end

		it "response is ok for a known hook" do
			head "/hook/auto-version"
			expect(last_response).to be_ok
		end
	end

	describe '.verify_signature' do
		context 'when signature is not equal' do
			let(:hash) {"1234567890abcdef"}
			it { expect { subject.verify_signature(payload_body, callback_URL, hash, trello_key) }.to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end
		
		context 'when signature is equal' do
			let(:hash) { Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), trello_key, payload_body+callback_URL)) }
			it { expect { subject.verify_signature(payload_body, callback_URL, hash, trello_key) }.not_to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end

		context 'when umlauts in payload with binary encoded payload' do
			let(:payload_body) {'{"test":"bödy"}'}
			let(:hash) { Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), trello_key, (payload_body+callback_URL).unpack('U*').pack('c*'))) }
			it { expect { subject.verify_signature(payload_body, callback_URL, hash, trello_key) }.not_to throw_symbol(:halt, [500, "Signatures didn't match!"]) }
		end
	end
end