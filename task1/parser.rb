require 'nokogiri'
require 'pry'
require 'date'

search_file = File.open "search.xml"
doc = Nokogiri::Slop(search_file)
search_file.close

search_results = doc.xpath('//searchresults//searchresult')

search_results.each do |result|
  result_id = result.id.text
  connections = result.connections.connection
  connections.each do |connection|
    start = connection.start.text
    finish = connection.finish.text
    departure_time = DateTime.parse(connection.departuretime.text)
    arrival_time = DateTime.parse(connection.arrivaltime.text)
    train_name = connection.trainname.text

  end
end


binding.pry


puts doc
