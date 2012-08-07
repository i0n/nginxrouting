require 'rest_client'
require 'spreadsheet'
require 'trollop'

opts = Trollop::options do
	banner <<-EOS

Script takes a file containing urls and runs them against a specified domain.

Don't use any of the these options if you want to run the default test.

EOS
	opt :file, "Spreadsheet (xls) to take the URLs from", :short => "f", :default => 'spreadsheets/bizlink_ip_mappings.xls'
	opt :column, "Column to take the URLs from (if more than one column in spreadsheet) - start at 0", :short => "c", :default => 0
	opt :domain, "The domain to convert the urls to (e.g. entering 'google.com' will replace 'http://yahoo.com/search=this' with 'http://google.com/search=this' )", :short => 'd'
	
end

# get domain
idom = ARGV[0] if opts[:domain]
puts "URLs will be converted to use this domain: #{idom}" if idom

# get file
puts "Spreadsheet: #{opts[:file]}"

# get column
puts "Column: #{opts[:column]}"

# open excel spreadsheet from Ben
book = Spreadsheet.open opts[:file]
# get first worksheet
front = book.worksheet 0


# array of old_urls only
old_urls = []
front.each 1 do |row|
	old_urls << row[opts[:column]]
end

def revise_url idom=false, url
	# replace current domain with input domain
	unless idom
		url
	else
		# not perfect, but does the job for the moment
		url.gsub(/\/\/.*?\//, "//#{idom}/")
	end
end

# cycle through  
old_urls[0..2].each do |u|
	revised_url = revise_url(idom,u)
	
	op = [u,revised_url]

	RestClient.get(revised_url) { |response, request, result, &block|
		case response.code
		when 200 
			op.unshift 'alive'
		when 302, 301
			op.unshift 'redirected'
		when 400, 404 
			op.unshift 'not found'
		else 
			op.unshift 'unrecognised'
		end

		op << response.headers
		puts op.to_s
	}
end



if false
	# collection of old_url, clean_url and govuk_url
	collected = []
	# uses function from spreadsheet gem to exclude the first row
	front.each 1 do |row|
		collected << [
			row[2], row[3], row[11]
		]
	end

	old_urls = collected.map { |e| e[0] }

end