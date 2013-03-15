#!/bin/env ruby
# encoding: utf-8

require "net/http"
require "mongo_mapper"

#check gem for windows 
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You have to run \'gem install win32console\' to use color on Windows'
end

class String
    # colorize functions
    def red; colorize(self, "\e[1m\e[31m"); end
    def green; colorize(self, "\e[1m\e[32m"); end
    def colorize(text, color_code) "#{color_code}#{text}\e[0m" ; end
end

class Washi
	def initialize()
		@key1 = "Waschschhscihahaischihwaschiw45"
		@key2 = "1087409385898FAFASDTEGAJAN"
		@serverList = getServerList()

		if @serverList == nil
			puts "No server were found!"
		end

		begin
			@mode = ENV.fetch("mode")	
		rescue Exception => e
			@mode = "client"
		end
	end

	def mode
		return @mode
	end

	def printServerList()
		@serverList.each do |server|
			server["receive.php"] = ""
			puts server
		end
	end

	def find(object)
		if object == nil
			return "You need a object to wasch! Use -f object or --find object"
		end
		if object == "--object"
			object = randomPointlessWord
		end
		@serverList.each do |uri|
			begin
				uri["receive.php"]= "found"
				url = URI(uri)
				res = Net::HTTP.get(url).index(object)
				uri["found"] = ""
				if res != nil
					puts "[OK]        ".green + uri
				else
					puts "[Not Found] ".red + uri
				end
			rescue Exception => e
				#well skip
			end
		end
	end

	def wash(object)
		if object == nil
			return "You need a object to wash! Use -w object or --wash object"
		end
		if object == "--object"
			object = randomPointlessWord
		end
		begin
			serverUrl = @serverList.sample
			puts serverUrl
			serverUrl["receive"]= "echowash"
			url = URI(serverUrl)
			res = Net::HTTP.post_form(url, 'key1' => @key1, 'key2'=> @key2, "Kleidung" => object)
			serverUrl["echowash.php"] = ""
			if @mode == "lib"
				return htmlDecoding(res.body) + " from Server: " + serverUrl
			else
				return htmlDecoding(res.body) + "\n->your " + object + " from Server: " + serverUrl
			end
		rescue Exception => e
			#well skip
			puts e
			printServerList()
		end
	end

	def getHelp()
		return <<-EOF 
Ruby-client for http://waschi.org
Usage:
   -w object or --wash object      Wash some object
   -f object or --find object      Find some object
   --serverlist                    Print a list with the Servers

   If you have no idea for an object you can generate one with
   --object
   Example:
   -f --object
   EOF
	end

	private
	def getServerList()
		url = URI('http://waschi.meikodis.org/servers.php')
		res = Net::HTTP.post_form(url, 'key1' => @key1, 'key2'=> @key2)
		serverList = res.body.split(/\n/);
		if serverList == nil
			getServerList()
		end
		return serverList
	end

	def randomPointlessWord()
		begin
			url = URI("http://dev.revengeday.de/pointlesswords/api/")
			res = Net::HTTP.get(url)
			return htmlDecoding(res)
		rescue Exception => e
			return "NotReallyRandom"
		end
	end

	def htmlDecoding(string)
		return string.gsub("&auml;", "ä").gsub("&uuml;", "ü").gsub("&ouml;", "ö").gsub("&Auml;", "Ä").gsub("&Uuml;", "Ü").gsub("&Ouml;", "Ö").gsub("&szlig;", "ß")
	end
end

w = Washi.new
if w.mode != "lib"
	case ARGV[0]
		when "-w"
			puts w.wash(ARGV[1])
		when "--wash"
			puts w.wash(ARGV[1])
		when "-f"
			w.find(ARGV[1])
		when "--find"
			w.find(ARGV[1])
		when "--serverlist"
			w.printServerList
		else
		  puts w.getHelp
	end
end