#!/usr/bin/env ruby

ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rest_client'
require 'spreadsheet'
require 'trollop'

opts = Trollop::options do
	banner <<-EOS

Script takes a file containing urls and runs them against a specified domain.

Usage: script/test_routes [-f /path/to/spreadsheet.xls] [-c column] [-d www.domain.com] [-r] [-s 2]

Demo: script/test_routes -d nginxrouting.dev.gov.uk -l 2

Options:
----

EOS
	opt :file, "Spreadsheet (xls) to take the URLs from", :short => "f", :default => "#{ROOT_PATH}/spreadsheets/bizlink_ip_mappings.xls"
	opt :column, "Column to take the URLs from (if more than one column in spreadsheet) - start at 0", :short => "l", :default => 0
	opt :mode, "Mode to run the script in: 'visit' - Visit the urls created and return the headers - script will take longer to run; 'urlcheck' - Checks the urls for itemId and topicId", 
		:short => "m", :default => "visit"
	opt :domain, "The domain to convert the urls to (e.g. entering 'google.com' will replace 'http://yahoo.com/search=this' with 'http://google.com/search=this' )", :short => 'd'
	opt :headers, "Include the response headers.", :short => "r"
	opt :csv, "File & path to output results (.csv)", :short => "c"
	opt :skiprows, "Skips rows at the start of the spreadsheet (i.e. headers", :short => "s", :default => 1	
	opt :debug, "Debug mode - only passes against the the first 3 urls", :short => "g", :default => true 

end

# display if in debug mode
debug_str =<<-EOS
==========
DEBUG MODE
==========

Script will only capture first 3 urls.

==========
EOS

puts debug_str if opts[:debug]


def grab_urls spreadsheet_file, spreadsheet_column, spreadsheet_skiprows
	# grab_urls opts[:file], opts[:column], opts[:skiprows]

	# get file
	puts "Loading Spreadsheet: #{spreadsheet_file}"

	# open excel spreadsheet from Ben
	book = Spreadsheet.open spreadsheet_file
	# get first worksheet
	front = book.worksheet 0

	# get column
	puts "Extracting URLs from Column: #{spreadsheet_column}"

	# array of old_urls only
	old_urls = []
	# this is a Spreadsheet gem override of the 'each' iterator
	# TODO: figure out how to use 'map' instead, maybe?
	front.each spreadsheet_skiprows do |row|
		old_urls << row[spreadsheet_column]
	end

	return old_urls
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

case opts[:mode]
when "visit"

	visit_message =<<-EOS
==========
VISIT MODE
==========

Script will visit every url it creates (may take some time!).

==========
EOS

	puts visit_message

	# get domain
	if opts[:domain]
		idom = ARGV[0] 
		puts "URLs will be converted to use this domain: #{idom}" if idom
	else
		puts "Please enter a domain with the -d option (type -h for all the options)"
	end
	
	# array of old_urls only
	old_urls = grab_urls opts[:file], opts[:column], opts[:skiprows]

	

	# cycle through responses 
	#if false
	statement = "response\told_url\trevised_url\tresponse_url\tvars"
	statement += "\theaders" if opts[:headers]
	#puts statement
	#end

	# csv
	#to_csv = statement+"\n"

	local_filename = "urls_test_output_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
	file_out = File.open(local_filename, 'w')
	file_out.write(statement+"\n")


	coll = old_urls
	coll =  old_urls[0..2] if opts[:debug]
	coll.each do |u|
		break if u == nil # stop if empty space
		revised_url = revise_url(idom,u)
		#op = []
		#op << "OLD:\t\t"+u
		#op << "Revised:\t"+revised_url #if false
		op = [u,revised_url]

		RestClient.get(revised_url) { |response, request, result, &block|
			case response.code
			when 200 
				op.unshift 'Alive'
			when 302, 301
				op.unshift "Redirected"
			when 400, 404 
				op.unshift 'Not found'
			else 
				op.unshift 'Unrecognised'
			end
			#op << "NEW:\t\t" + response.headers[:location]	
			op << response.headers[:location]	
			report_line = [op.first, op.last]
			op << response.headers if opts[:headers]
			
			unless response.headers[:itemid] or response.headers[:resources] or response.headers[:topicid]
				report_line << "no vars!" 
				op << "no vars!"
			else
				op << [response.headers[:itemid],response.headers[:resources],response.headers[:topicid]].join(',')
			end

			puts report_line.join(" | ")


			#puts op.join("\n\t")
			#to_csv += op.join("\t")+"\n"
			file_out.write(op.join("\t")+"\n")
		}
	end

	file_out.close
	#File.open(local_filename, 'w') {|f| f.write(to_csv) }
	puts "output written to #{local_filename}"

when "urlcheck"
	urlcheck_message =<<-EOS
==============
URL CHECK MODE
==============

Script will run each url for itemId and typeId

(Not yet implemented - please select another mode)

==========
EOS

else
	puts "Mode not found. Please run --help"
end

if false
	# redundant code - reads in all urls in Ben's spreadsheet urls
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
