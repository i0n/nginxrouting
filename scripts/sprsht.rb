require 'spreadsheet'

# open excel spreadsheet from Ben
book = Spreadsheet.open 'bizlink_ip_mappings.xls'
# get first worksheet
front = book.worksheet 0

# collection of old_url, clean_url and govuk_url
collected = []
front.each 1 do |row|
	collected << [
		row[2], row[3], row[11]
	]
end

# array of old_urls only
old_urls = collected.map { |e| e[0] }

#puts 'success' #DEBUG