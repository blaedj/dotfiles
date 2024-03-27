#!/usr/bin/env ruby
require "cgi"
require "uri"
require "json"
require "net/http"

#
# Sends a request to the Internal1P Alfred endpoint
#
# @param [String] path The path starting after "/alfred"
# @param [String] query An optional query string
# @return [AlfredResponse] A JSON Alfred response
#
def get_response(path, query)
	raise "\"path\" cannot be empty" if path.empty?

	# Prepend a forward slash if it's missing
	path = "/#{path}" unless path.start_with?("/")

	# Build the URL
	url = URI("#{ENV["host"]}/alfred#{path}")

	unless query.empty?
		url.query = URI.encode_www_form(:q => query)
	end

	# Send the request
	Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') do |http|
		request = Net::HTTP::Get.new(url)
		request["User-Agent"] = "Alfred"
		request["Authorization"] = "Bearer #{ENV["token"]}"
		http.request(request).read_body
	end
end