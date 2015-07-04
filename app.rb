require_relative 'app/models/bot'

filename = ENV["FILENAME"]
Bot.new(filename).populate!
