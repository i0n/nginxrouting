require 'CSV'

puts 'DEBUG: script start'


# spreadsheets
logs_fn = 'spreadsheets/akamai-70750-Total-stripped.csv'
bl_fn = 'spreadsheets/bens_full_bl.csv'

# get ben's CSV and rip itemids and topicids to memory
bl_lines = CSV.read(bl_fn, :col_sep => "\t")
bl_itemids = []
bl_topicids = []
bl_itemids = bl_lines.map{ |l| l[4].to_i.to_s unless l[4].nil? or l[4].length < 3 or bl_itemids.include? l[4].to_i.to_s }
bl_topicids = bl_lines.map{ |l| l[5].to_i.to_s unless l[5].nil? or l[5].length < 3 or bl_topicids.include? l[5].to_i.to_s}


# iterate through akamai logs and compare any itemids or topicids found
logs_lines = File.readlines(logs_fn)

logs_hasit = [] 
logs_notit = []

logs_hastp = []
logs_nottp = []


logs_lines.each_with_index{ |l,i| 
	out = $1 if l =~ /itemid=([\d]{10,})/i 
	unless out.nil? or out.length < 3
		if bl_itemids.include? out
			logs_hasit << out
		else
			logs_notit << out
		end
	end
	topic = $1 if l =~ /topicid=([\d]{10,})/i
	unless topic.nil? or topic.length < 3
		if bl_topicids.include? topic
			logs_hastp << topic
		else
			logs_nottp << topic
		end
	end
	puts "processed #{i} lines" if i % 1000 == 0 
	}

p logs_lines.length

p logs_hasit.length
p logs_notit.length

p logs_hastp.length
p logs_nottp.length

fn1 = "itemidsnotfound_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
fn2 = "topicidsnotfound_"+ Time.now.strftime("%Y%m%d%H%M%S") +".csv"
File.open(fn1, 'w') {|f| f.write(logs_notit.join("\n")) }
File.open(fn2, 'w') {|f| f.write(logs_nottp.join("\n")) }


puts 'DEBUG: script end'