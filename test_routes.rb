require 'rest_client'

# initial RestClient test
RestClient.get ('http://rjjm.net/hallve') { |response, request, result, &block|

case response.code
when 200
	puts 'yay!'
when 301
	puts 'dey muuved id!'
when 404
 	puts 'boo!'
else 
	puts 'hmm?'
#	response.return!(request, result, &block)
end 
}

#TODO: grab the CSV
#CSV.open("path/or/url/or/pipe", "r") { |io|  }
#TODO: iterate and test urls
