#!/bin/env ruby
# encoding: utf-8

require 'json'
require 'net/http'
require 'uri'
require 'logger'
require 'pstore'

#set libmode for washi.rb
ENV["mode"] = "lib"
require_relative '../washi.rb'

#config
@outserver = "identi.ca"
@user = "washibot"
@pass = ""

#setup
@log = Logger.new('washi.log')
store = PStore.new('washi.pstore')

def open(url)
  Net::HTTP.get(URI.parse(url))
end

def postOnStatusNet(status)
	status[0 .. 139]
	url = URI.parse('http://' + @outserver + '/api/statuses/update.json')
	req = Net::HTTP::Post.new(url.path)
	req.basic_auth @user, @pass
	req.set_form_data('status' => status, "source" => "washident")

	resp = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
	@log.info resp
	return resp.body
end

w = Washi.new
loop do
	#collect data
	json_string = JSON.parse(open("http://identi.ca/api/statusnet/groups/timeline/54796.as"))

	json_string["items"].each do |eintrag|
		item = eintrag["title"].downcase
		id = eintrag["object"]["id"]
		user = eintrag["actor"]["contact"]["preferredUsername"]

		if(item.index("!waschi cli ") != nil)
			item["!waschi cli "]= ""

			store.transaction(true) do
				 @lastId = store["lastId"]
			end
			if @lastId == id
				break
			end

			if item != ""
				store.transaction do
				  store['lastId'] = id
				end

				respons = postOnStatusNet("Hey @" + user.to_s + " " + w.wash(item).to_s)

				if respons.index("error") != nil
					@log.error respons
				else
					@log.info "Hey @" + user.to_s + " " + w.wash(item).to_s
				end
			end
		end
	end
	sleep 120
end