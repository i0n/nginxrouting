# bl_load_mappings.rb

require 'csv'

# open ben's bl mappings CSv (created)

# unless ARGV[0]
# 	puts 'please enter file path for the bl urls'
# 	exit
# end
blfn = ARGV[0] 
file2 = ARGV[1]
# blfn = ARGV[0] || 'spreadsheet/bens_full_bl.csv'
puts "using #{blfn} and #{file2}"

blcsv = CSV.read(blfn) #, :col_sep => "\t"
csv2 = CSV.read(file2) #, :col_sep => "\t"


extracted = []
collected = []
blcsv.each do |r|

	# istr = $1 if r[0] =~ /([A-Z0-9\.]+)$/
	# puts istr if csv2.include? istr 
	# collected  << r unless csv2.include? istr
	if r[0] =~ /[A-Z]{2}[0-9]{4,}/
		collected  << r.join(',') 
	else
		extracted << r.join(',')
	end 

end

puts blcsv.length
puts collected.length
puts csv2.length

fn1 = "atomids_collected_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
fn2 = "atomids_extracted_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
File.open(fn1, 'w') {|f| f.write(collected.join("\n")) }
File.open(fn2, 'w') {|f| f.write(extracted.join("\n")) }


#  grab the canoncical urls (clean urls?)
# mappings array: [0] old, [1] clean, [2] gov.uk


# Mapping.where(:new_url.nin => ["", nil]) # Get all the mappings where there are notes and queries

# Mapping _id: 4fbe3a4aa4254a322c0017da, _type: nil, tagged_with_ids: [BSON::ObjectId('4fb6479aa4254a077d000002'), BSON::ObjectId('4fb257ffa4254a0ac5000014'), BSON::ObjectId('4fb257f6a4254a0ac5000009'), BSON::ObjectId('4fbe3a4aa4254a322c0017db'), BSON::ObjectId('4fb257f8a4254a0ac500000b'), BSON::ObjectId('4fe1b459a4254a24be000004')], tags_cache: ["content-type:alias", "destination:content", "site:directgov", "source:aliases", "status:closed"], tags_list_cache: "content-type:alias, destination:content, site:directgov, source:aliases, status:closed", version: 1, modifier_id: nil, title: "14-19prospectus", old_url: "http://www.direct.gov.uk/14-19prospectus", new_url: "https://www.gov.uk/courses-qualifications", status: 301, notes: "Currently redirects to http://yp.direct.gov.uk/14-19prospectus/"

#ins_str = "#{blcsv[1]} "

#TODO:  insert into dev mongodb with 'canonical' tag
#TODO: 	view results
