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
			puts "No server where found!"
		end
	end

	def printServerList()
		@serverList.each do |server|
			server["receive.php"] = ""
			puts server
		end
	end

	def find(thing)
		if thing == nil
			return "You need a thing to wasch! Use -f thing or --find thing"
		end
		if thing == "-thing"
			thing = randomPointlessWord
		end
		found = false
		@serverList.each do |uri|
			begin
				uri["receive.php"]= "found"
				url = URI(uri)
				res = Net::HTTP.get(url).index(thing)
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
			puts "Yeah we found \"" + thing + "\""
		else
			puts "Sorry we don't found \"" + thing + "\", If you want you can Wasch it ;)"
		end

	end

	def wash(thing)
		if thing == nil
			return "You need a thing to wasch! Use -w thing or --wasch thing"
		end
		if thing == "-thing"
			thing = randomPointlessWord
		end
		begin
			server = @serverList.sample
			server["receive"]= "echowash"
			url = URI(server)
			res = Net::HTTP.post_form(url, 'key1' => @key1, 'key2'=> @key2, "Kleidung" => thing)
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
   -w thing or --wasch thing     Wash something
   -f thing or --find thing      Find something
   -serverlist                   Print the list with the Servers

   If you have no idea for a thing you can gerate one with
   -thing
   Example:
   -f -thing
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
		return string.gsub("&auml;", "ä").gsub("&uuml;", "ü").gsub("&ouml;", "ö")
	end
end


w = Washi.new
case ARGV[0]
	when "-w"
		w.wash(ARGV[1])
	when "--wasch"
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