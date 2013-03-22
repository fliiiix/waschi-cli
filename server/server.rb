#!/bin/env ruby
# encoding: utf-8

require 'json'
require 'net/http'
require 'uri'

#set libmode for washi.rb
ENV["mode"] = "lib"
require_relative '../washi.rb'

#config
@outserver = "identi.ca"
@user = "washibot"
@pass = ENV["washiPW"]

MongoMapper.connection = Mongo::Connection.new('localhost', 20799)
MongoMapper.database = "dentDB"
MongoMapper.database.authenticate(@user, @pass)

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
	return resp.body
end


w = Washi.new
#collect data
json_string = JSON.parse(open("http://identi.ca/api/statusnet/groups/timeline/54796.as"))

json_string["items"].each do |eintrag|
	begin
		item = eintrag["title"].downcase
		id = eintrag["url"]
		user = eintrag["actor"]["contact"]["preferredUsername"]
	rescue Exception => e
		Log.new(:art => Status::Error, :message => e).save
		break
	end
		
	if(item.index("!waschi cli ") != nil)
		item["!waschi cli "]= ""

		if item != nil && item != ""  && Dent.where(:userId => id).first == nil
			res = postOnStatusNet("!waschi Hey @" + user + " " + w.wash(item))
			if res != nil && res.index("error") == nil
				dent = Dent.new(:userId => id, :item => item, :user => user, :status => Status::Info)
				dent.save
			end
		end
	end
end