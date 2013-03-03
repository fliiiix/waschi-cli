#!/bin/env ruby
# encoding: utf-8

require "net/http"
#check gem for windows 
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows'
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
		if object == "-object"
			object = randomPointlessWord
		end
		found = false
		@serverList.each do |uri|
			begin
				uri["receive.php"]= "found"
				url = URI(uri)
				res = Net::HTTP.get(url).index(object)
				uri["found"] = ""
				if res != nil
					found = true
					puts "[OK]   ".green + uri
				else
					puts "[FAIL] ".red + uri
				end
			rescue Exception => e
				#well skip
			end
		end
		if found
			puts "Yeah, we found \"" + object + "\""
		else
			puts "Sorry, we haven't found \"" + object + "\", If you want you can Wasch it ;)"
		end

	end

	def wash(object)
		if object == nil
			return "You need a object to wash! Use -w object or --wash object"
		end
		if object == "-object"
			object = randomPointlessWord
		end
		begin
			server = @serverList.sample
			server["receive"]= "echowash"
			url = URI(server)
			res = Net::HTTP.post_form(url, 'key1' => @key1, 'key2'=> @key2, "Kleidung" => object)
			server["echowash.php"] = ""
			puts htmlDecoding(res.body)
			puts "-> from server: " + server
		rescue Exception => e
			#well skip
		end
	end

	def printHelp()
		puts <<-EOF 
Ruby-client for http://waschi.org
Usage:
   -w object or --wash object      Wash someobject
   -f object or --find object      Find someobject
   -serverlist                     Print the list with the Servers

   If you have no idea for a object you can gerate one with
   -object
   Example:
   -f -object
   EOF
	end

	private
	def getServerList()
		url = URI('http://waschi.meikodis.org/servers.php')
		res = Net::HTTP.post_form(url, 'key1' => @key1, 'key2'=> @key2)
		serverList = res.body.split(/\n/);
		return serverList
	end

	def randomPointlessWord()
		url = URI("http://dev.revengeday.de/pointlesswords/api/")
		res = Net::HTTP.get(url)
		return htmlDecoding(res)
	end

	def htmlDecoding(string)
		return string.gsub("&auml;", "ä").gsub("&uuml;", "ü").gsub("&ouml;", "ö").gsub("&Auml;", "Ä").gsub("&Uuml;", "Ü").gsub("&Ouml;", "Ö").gsub("&szlig;", "ß")
	end
end


w = Washi.new
case ARGV[0]
	when "-w"
		w.wash(ARGV[1])
	when "--wash"
		w.wash(ARGV[1])
	when "-f"
		w.find(ARGV[1])
	when "--find"
		w.find(ARGV[1])
	when "-serverlist"
		w.printServerList
	else
	  w.printHelp
end