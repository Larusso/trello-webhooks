RSpec::Matchers.define :be_boolean do
  match do |actual|
    actual == true || actual == false
  end
end