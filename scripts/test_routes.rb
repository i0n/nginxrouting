require 'rest_client'
require 'spreadsheet'

# open excel spreadsheet from Ben
book = Spreadsheet.open 'bizlink_ip_mappings.xls'
# get first worksheet
front = book.worksheet 0

# collection of old_url, clean_url and govuk_url
collected = []
# uses function from spreadsheet gem to exclude the first row
front.each 1 do |row|
	collected << [
		row[2], row[3], row[11]
	]
end

# array of old_urls only
old_urls = collected.map { |e| e[0] }

# cycle through  
old_urls[0..2].each do |u|
	# TODO: revise url 
	RestClient.get(u) { |response, request, result, &block|
		case response.code
		when 200 
			puts 'alive'
		when 301 
			puts 'redirected'
		when 400 
			puts 'not found'
		else 
			puts 'unrecognised'
		end
	}
end


