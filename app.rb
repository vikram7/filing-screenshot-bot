require_relative 'app/models/bot'

filename = ENV["FILENAME"]
print "How many do you want to populate with?: "
count = gets.chomp.to_i
puts "No problem!"

print "Do you want to (1) create images or (2) count hrefs?: "
choice = gets.chomp.to_i

if choice == 1
  puts "Starting imagemaker!"
  Bot.new(filename).populate!(count)
else
  puts "Starting counter!"
  HrefCounter.new(filename).counter(count)
end
