#!/usr/bin/env ruby
require "./util.rb"

# Splits the input by the first space only,
# giving us our keyword at index 0 and the 
# rest of our query as a string at index 1
keyword, *args = ARGV[0].split(" ")

puts get_response("/fly/#{keyword}", args.join(" "));