require 'json'

RSpec::Matchers.define :be_json do
	match do |actual|
		JSON.parse(actual) rescue return false
		true
	end
end