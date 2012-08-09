# filter_spreadsheet.rb
require 'csv'

unless ARGV[0]
	puts "Please enter the path of the CSV of urls to process."
	exit
end

csvf = ARGV[0]

urls = CSV.read(csvf)

urls.shift
puts urls.length

excpts = []

ec = 0
urls.each do |line|
	url = line[0]

	# if url.include? 'itemId' or url.include? 'topicId'
	# if url =~ /itemid/i or url =~ /topicid/i or url =~ /\/help/ or url =~ /staticpage/ or url =~ /diol/i or url =~ /\/home/
	unless url =~ /bdotg\/action\/[A-Z0-9\.]*?$/ 
 		print '.'
	else
		excpts << $1 if url =~ /bdotg\/action\/([A-Z0-9\.]*?)$/ 
		ec += 1
		print '/'
	end
	
end	


local_filename = "biz_link_atomids_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
File.open(local_filename, 'w') {|f| f.write(excpts.join("\n")) }


puts '', ec, 'script complete'
