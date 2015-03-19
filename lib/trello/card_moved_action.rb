require 'trello'

module Trello
	class CardMovedAction < Action

		register_attributes :from_list_id, :to_list_id, readonly: [ :from_list_id, :to_list_id ]

		def self.convert_from_action action
			client.get("/actions/#{action.id}").json_into(self)
		end

		def update_fields(fields)
			super fields
			
			if fields['data'].include? "listAfter" 
      			attributes[:to_list_id] = fields['data']['listAfter']['id']
      		end

      		if fields['data'].include? "listBefore" 
      			attributes[:from_list_id] = fields['data']['listBefore']['id']
      		end
    		self
    	end

    	def from_list
    		return nil unless valid?
      		client.get("/lists/#{from_list_id}").json_into(Card)
    	end

    	def to_list
    		return nil unless valid?
      		client.get("/lists/#{to_list_id}").json_into(Card)
    	end

		def valid?
			from_list_id and to_list_id
		end		
	end
end