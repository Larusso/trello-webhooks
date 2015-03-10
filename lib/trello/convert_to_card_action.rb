require 'trello'

module Trello
	class ConvertToCardAction < Action

		register_attributes :source_card_id
		validates_presence_of :source_card_id

		def update_fields(fields)
			super fields
			if fields['data'].include? "cardSource" 
      			attributes[:source_card_id] = fields['data']['cardSource']['id']
      		end
    		self
    	end

    	def source_card
    		return nil unless valid?
      		client.get("/cards/#{source_card_id}").json_into(Card)
    	end

		def valid?
			source_card_id && type.eql?("convertToCardFromCheckItem")
		end		
	end
end