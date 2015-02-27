require 'logger'

module Hooks
	autoload :AutoVersion, 'hooks/auto_version'
	autoload :AutoAssign,  'hooks/auto_assign'

	def self.logger
		@logger ||= Logger.new(STDOUT)
	end

	def self.logger=(logger)
		@logger = logger
	end
end