require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'hooks'
require 'trello'
require 'json'
require 'trello/convert_to_card_action'
require 'trello/card_moved_action'

ENV['TRELLO_KEY'] = "test_key"
ENV['TRELLO_MEMBER_TOKEN'] = "test_token"

module Helpers

	def allow_get url, params, return_value
		allow(client).to receive(:get).with(url).
			and_return return_value

		allow(client).to receive(:get).with(url, params).
			and_return return_value
	end

	def allow_put url, params, return_value
		allow(client).to receive(:put).with(url).
			and_return return_value

		allow(client).to receive(:put).with(url, params).
			and_return return_value
	end

	def allow_post url, params, return_value
		allow(client).to receive(:post).with(url).
			and_return return_value

		allow(client).to receive(:post).with(url, params).
			and_return return_value
	end

	def user_details
		{
			'id' => 'abcdef123456789123456789',
			'fullName' => 'Test User',
			'username' => 'me',
			'intials' => 'TU',
			'avatarHash' => 'abcdef1234567890abcdef1234567890',
			'bio' => 'a rather dumb user',
			'url' => 'https://trello.com/me',
			'email' => 'johnsmith@example.com'
		}
	end

	def user_payload
		JSON.generate(user_details)
	end

	def boards_details
		{
			'id' => 'abcdef123456789123456789',
			'name' => 'Test',
			'desc' => 'This is a test board',
			'closed' => false,
			'idOrganization' => 'abcdef123456789123456789',
			'url' => 'https://trello.com/board/test/abcdef123456789123456789'
		}
	end

	def boards_payload
		JSON.generate(boards_details)
	end

	def board_labels key
		[
			{
				"id" => "54656d9574d650d5672a06df",
				"idBoard" => "53d77b7e8b272ed7c843a943",
				"name"=> "4.5.6",
				"color" => "green",
				"uses" => 2
			},
			{
				"id" => "54656d9574d650d5672a06df",
				"idBoard" => "53d77b7e8b272ed7c843a943",
				"name"=> "1.2.3",
				"color" => "green",
				"uses" => 2
			},
			{
				"id" => "54656d9574d650d5672a06df",
				"idBoard" => "53d77b7e8b272ed7c843a943",
				"name"=> "UI",
				"color" => "green",
				"uses" => 2
			},
			{
				"id" => "54656d9574d650d5672a06df",
				"idBoard" => "53d77b7e8b272ed7c843a943",
				"name"=> "Bug",
				"color" => "green",
				"uses" => 2
			},
			{
				"id" => "54656d9574d650d5672a06df",
				"idBoard" => "53d77b7e8b272ed7c843a943",
				"name"=> "Blocker",
				"color" => "green",
				"uses" => 2
			}
		]
	end

	def version_label version
		{
			"id" => "abcdef123456789123456789",
			"idBoard" => "53d77b7e8b272ed7c843a943",
			"name"=> version,
			"color" => "green",
			"uses" => 2
		}
	end

	def board_labels_payload key
		JSON.generate(board_labels(key))
	end

	def action_details key
		d = {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'card' => {
						'id' => 'abcdef123456789123456789',
						'name' => 'Bytecode outputter'
					},
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
					'list' => {
						'id' => '4ee238b034a81a757a05cda0',
						'name' => 'TODO 0.1.1'
					}
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'createCard'
			}
		{
			create_card: {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'card' => {
						'id' => 'abcdef123456789123456789',
						'name' => 'Bytecode outputter'
					},
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
					'list' => {
						'id' => '4ee238b034a81a757a05cda0',
						'name' => 'TODO 0.1.1'
					}
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'createCard'
			},
			move_card: {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'listAfter' => {
						"name"=> "todo 1.33.4",
						"id"=> "54eef8a54e22aeee50bcee3f"
					},
					"listBefore"=> {
						"name" => "Done",
						"id" => "53d77b7e8b272ed7c843a946"
					},
					'card' => {
						'id' => 'abcdef123456789123456789',
						'name' => 'Bytecode outputter'
					},
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
					"old" => {
						"idList" => "4ee238b034a81a757a05cda0"
					}
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'updateCard'
			},
			list_update: {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
					'list' => {
						'id' => '4ee238b034a81a757a05cda0',
						'name' => 'TODO 0.1.1'
					},
					"old" => {
						"name"=> "test"
					}
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'updateList'
			},
			card_moved_doing: {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'listAfter' => {
						"name"=> "todo 1.33.4",
						"id"=> "54eef8a54e22aeee50bcee3f"
					},
					"listBefore"=> {
						"name" => "Done",
						"id" => "53d77b7e8b272ed7c843a946"
					},
					'card' => {
						'id' => 'abcdef123456789123456789',
						'name' => 'Bytecode outputter'
					},
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
					"old" => {
						"idList" => "4ee238b034a81a757a05cda0"
					}
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'updateCard'
			},
			convert_card: {
				'id' => 'abcdef123456789123456789',
				'idMemberCreator' => 'abcdef123456789123456789',
				'data'=> {
					'cardSource' => {
						"shortLink" => "D8IsnJqS",
						"idShort" => 21,
						"name"=> "Test Card",
						"id"=> "54eef8a54e22aeee50bcee3f"
					},
					"list"=> {
						"name" => "Done",
						"id" => "53d77b7e8b272ed7c843a946"
					},
					'card' => {
						'id' => 'abcdef123456789123456789',
						'name' => 'Bytecode outputter'
					},
					'board' => {
						'id' => '4ec54f2f73820a0dea0d1f0e',
						'name' => 'Caribou VM'
					},
				},
				'date' => '2012-02-10T11:32:17Z',
				'type' => 'convertToCardFromCheckItem'
			}
		}.fetch(key,d)
	end

	def action_payload key
		JSON.generate(action_details(key))
	end

	def cards_details key
		{
			'id' => 'abcdef123456789123456789',
			'idShort' => '1',
			'name' => 'do stuff',
			'desc' => 'Awesome things are awesome.',
			'closed' => false,
			'idList' => 'abcdef123456789123456789',
			'idBoard' => 'abcdef123456789123456789',
			'idAttachmentCover' => 'abcdef123456789123456789',
			'idMembers' => ['fedcba987654321987654321'],
			'url' => 'https://trello.com/card/board/specify-the-type-and-scope-of-the-jit-in-a-lightweight-spec/abcdef123456789123456789/abcdef123456789123456789',
			'shortUrl' => 'https://trello.com/c/abcdef12',
			'pos' => 12,
			'dateLastActivity' => '2012-12-07T18:40:24.314Z'
		}
	end

	def cards_payload key
		JSON.generate(cards_details(key))
	end

	def lists_details key
		d = {
				'id' => 'abcdef123456789123456789',
				'name' => 'Todo 1.22.1',
				'closed' => false,
				'idBoard' => 'abcdef123456789123456789',
				'cards' => [cards_details(key),cards_details(key),cards_details(key)]
			}
		{
			card_moved_doing:
			{
				'id' => 'abcdef123456789123456789',
				'name' => 'Doing',
				'closed' => false,
				'idBoard' => 'abcdef123456789123456789',
				'cards' => [cards_details(key),cards_details(key),cards_details(key)]
			}
		}.fetch(key, d)
	end

	def lists_payload key
		JSON.generate(lists_details(key))
	end

	def checklists_details key=:default
	    [{
	    	'id'         => 'abcdef123456789123456789',
	    	'name'       => 'Test Checklist',
	    	'desc'       => 'A marvelous little checklist',
	    	'closed'     => false,
	     	'position'   => 16384,
	      	'url'        => 'https://trello.com/blah/blah',
	      	'idBoard'    => 'abcdef123456789123456789',
	      	'idList'     => 'abcdef123456789123456789',
	      	'idMembers'  => ['abcdef123456789123456789'],
	      	'checkItems' => { 'id' => 'ghijk987654321' }
	    }]
	end

	def named_checklist name
		{
	    	'id'         => 'namedabcdef123456789123456789',
	    	'name'       => name,
	    	'desc'       => 'A marvelous little checklist',
	    	'closed'     => false,
	     	'position'   => 16384,
	      	'url'        => 'https://trello.com/blah/blah',
	      	'idBoard'    => 'abcdef123456789123456789',
	      	'idList'     => 'abcdef123456789123456789',
	      	'idMembers'  => ['abcdef123456789123456789'],
	      	'checkItems' => { 'id' => 'ghijk987654321' }
	    }
	end

  	def checklists_payload key=:default
    	JSON.generate(checklists_details key)
  	end
end