require 'nokogiri'
require 'pry'
require 'date'

class search
  def initialize(args*)
    @routes = @args[:routes]
  end
end

class route
  def initialize(args*)
    @connections = @args[:connections]
    calculate_layovers
  end

  def num_connections
    @connections.count
  end

  def calculate_layovers
    @connections.each_cons do |prev_con, curr_con, next_conn|
      continue if prev_con.nil?
      curr_con.layover_wait = curr_con.departure_time - prev_con.arrival_time
    end
  end

  def total_travel_time
    @connections.last.arrival_time - @connections.first.departure_time
  end

end


class connection
  def initialize(args*)

  @start_station = @args[:start]
  @finish_station = @args[:finish]
  @departure_time = @args[:departure_time]
  @arrival_time = @args[:arrival_time]
  @train_name = @args[:train_name]

  def duration
    @arrival_time - @departure_time
  end

end

search_file = File.open "search.xml"
doc = Nokogiri::Slop(search_file)
search_file.close

search_results = doc.xpath('//searchresults//searchresult')

search_info = Array.new
search_results.each do |result|
  result_info = Array.new
  result_id = result.id.text
  connections = result.connections.connection
  connections.each do |connection|
    start = connection.start.text
    finish = connection.finish.text
    departure_time = DateTime.parse(connection.departuretime.text)
    arrival_time = DateTime.parse(connection.arrivaltime.text)
    train_name = connection.trainname.text
    duration = arrival_time - departure_time
    fares = connection_fares(connection.fares)
  end
end

def connection_fares (fare_data)
  fares = {}
  fare_data.each do |one_fare|
    fare_class = one_fare.children[1].text
    fares[fare_class][:currency] = one_fare.price.currency.text.to_f
    fares[fare_class][:value] =  fare_amount = one_fare.price.value.text.to_f
  end
end


binding.pry


puts doc
