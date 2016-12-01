require 'dm-core'
require 'dm-migrations'
require 'base64'
require 'digest'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
  property :role, String
  property :salt, String
end

DataMapper.finalize()

def new_salt
  SecureRandom.hex(16)
end

def hash_password(password, salt=new_salt)
  "{SSHA}" + Base64.encode64("#{Digest::SHA1.digest("#{password}#{salt}")}#{salt}").chomp
end

def check_password(password, ssha)
  decoded = Base64.decode64(ssha.gsub(/^{SSHA}/, ''))
  hash = decoded[0,20] # isolate the hash
  salt = decoded[20,-1] # isolate the salt
  hash_password(password, salt) == ssha
end


