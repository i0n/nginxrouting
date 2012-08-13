# compare_atomids
require 'spreadsheet'
require 'csv'

ben = ARGV[0]
atid = ARGV[1]

puts "#{ben} | #{atid}"


# open excel spreadsheet from Ben
book = Spreadsheet.open ben
# get first worksheet
front = book.worksheet 0

# array of old_urls only
# batomids = []
# this is a Spreadsheet gem override of the 'each' iterator
# TODO: figure out how to use 'map' instead, maybe?
# front.each 1 do |row|
# 	batomids << row.join(",")
# end

# redundant code - reads in all urls in Ben's spreadsheet urls
	# collection of old_url, clean_url and govuk_url
	collected = []
	# uses function from spreadsheet gem to exclude the first row
	front.each 1 do |row|
		line = [
			row[9], row[2], row[3], row[11]
		]
		collected << line.join(",")
	end

	# old_urls = collected.map { |e| e[0] }

fn = "bens_full_bl_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
File.open(fn, 'w') {|f| f.write(collected.join("\n")) }

exit


batomids = CSV.read(ben)
atomids = CSV.read(atid)

batomids.map! {|i| i[0]}
atomids.map! {|i| i[0]}

# find_me = 'EP0710.04'
# p atomids.include? find_me
# p batomids.include? find_me




at_there = []
at_not =[]
atomids.each do |ai|
	if batomids.include? ai
		at_there << ai
		print '.'
	else
		at_not << ai
		print '/'
	end
end

there_fn = "atomids_there_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
not_fn = "atomids_not_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
File.open(there_fn, 'w') {|f| f.write(at_there.join("\n")) }
File.open(not_fn, 'w') {|f| f.write(at_not.join("\n")) }



puts 'success'