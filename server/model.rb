require "mongo_mapper"

class DowncasedString
  def self.to_mongo(value)
    value.nil? ? nil : value.to_s.downcase
  end

  def self.from_mongo(value)
    to_mongo(value)
  end
end

module Status
  Info = 0
  Warning = 1
  Error = 2
end

class Dent
	include MongoMapper::Document

	key :userId, DowncasedString
	key :item, DowncasedString
	key :user, DowncasedString
	key :status, Integer
	timestamps!
end

class Log
	include MongoMapper::Document

	key :art, Integer
	key :message, String
	timestamps!
end