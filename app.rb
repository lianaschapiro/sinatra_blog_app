require "sinatra"
require "sinatra/activerecord"
require "./models.rb"

set :database, "sqlite3:myblogdb.sqlite3"