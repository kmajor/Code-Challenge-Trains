require 'nokogiri'
require 'date'

class Search
  attr_accessor :routes, :doc
  def initialize(args)
    @file = args[:file]
    @routes = Array.new
    load_file
    parse_file
  end

  def load_file
    search_file = File.open @file
    @doc = Nokogiri::Slop(search_file)
    search_file.close
  end

  def parse_file
    search_results = @doc.xpath('//searchresults//searchresult')
    search_results.each do |result|
      connections = Array.new
      route_id = result.id.text
      result.connections.connection.each do |xml_connection|
        connection = Connection.build_from_xml(xml_connection)
        connections << connection
      end
    @routes << Route.new({id: route_id, connections: connections})
    end
  end

  def cheapest_route
    @routes.sort_by(&:cheapest_fare).first
  end

  def quickest_route
    quickest = @routes.first
    @routes.each do |route|
      quickest = route if route.total_travel_time < quickest.total_travel_time
    end
    quickest
  end


end

class Route
  attr_accessor :connections, :id
  def initialize(args)
    @connections = args[:connections]
    @id = args[:id]
    calculate_layovers unless @connections.count < 2
  end

  def cheapest_fare
    lowest_fares = 0.00
    @connections.each do |connection|
      low_fare = nil
      connection.fares.each do |fare|
        low_fare = fare[1][:value] if low_fare.nil? || low_fare > fare[1][:value]
      end
      lowest_fares += low_fare
    end
    lowest_fares
  end

  def num_connections
    @connections.count
  end

  def calculate_layovers
    @connections.each_with_index do |connection, i|
      next if i == 0
      #subtracting timestamps returns diff in days, so multiple by 24 * 60
      @connections[i].layover_wait = ((connection.departure_time - @connections[i-1].arrival_time) * 24 * 60).to_i
    end
  end

  def total_travel_time
    #subtracting timestamps returns diff in days, so multiple by 24 * 60
    ((@connections.last.arrival_time - @connections.first.departure_time) * 24 * 60).to_i
  end

end


class Connection
  attr_accessor :layover_wait, :arrival_time, :departure_time, :finish_station, :start_station, :train_name, :fares
  def initialize(args)
    @start_station = args[:start]
    @finish_station = args[:finish]
    @departure_time = args[:departure_time]
    @arrival_time = args[:arrival_time]
    @train_name = args[:train_name]
    @fares = args[:fares]
  end

  def self.build_from_xml(xml_connection)
    connection = {}
    connection[:start] = xml_connection.start.text
    connection[:finish] = xml_connection.finish.text
    connection[:departure_time] = DateTime.parse(xml_connection.departuretime.text)
    connection[:arrival_time] = DateTime.parse(xml_connection.arrivaltime.text)
    connection[:train_name] = xml_connection.trainname.text
    connection[:duration] = connection[:arrival_time] - connection[:departure_time]
    connection[:fares] = connection_fares(xml_connection.fares)
    return Connection.new(connection)
  end

  def self.connection_fares (fare_data)
    fares = {}
    fare_data.fare.each do |fare|
      klass = fare.children[1].text
      fares[klass]= {}
      fares[klass][:currency] = fare.price.currency.text
      fares[klass][:value] = fare.price.value.text.to_f
    end
    fares
  end

  def duration
    #subtracting timestamps returns diff in days, so multiple by 24 * 60
    ((@arrival_time - @departure_time) * 24 * 60).to_i
  end
end

def display_search
  puts "Hello Loco2 Peoples, here are your search results...."
  puts ""
  search = Search.new({file: 'search.xml'})
  puts "Total # of routes: #{search.routes.count}"
  search.routes.each do |route|
    puts "  Route ID: #{route.id}"
    puts "  Number of connections: #{(route.num_connections-1)}"
    puts "  Total Trip Duration: #{route.total_travel_time} minutes"
    puts "  Connections:"
    route.connections.each do |connection|
      puts "    Waiting Time: #{connection.layover_wait} minutes" unless connection.layover_wait.nil?
      puts "    Train Name: #{connection.train_name}"
      puts "    Start Station: #{connection.start_station}"
      puts "    Arrival Station: #{connection.finish_station}"
      puts "    Departure Time: #{connection.departure_time}"
      puts "    Arrival Time: #{connection.arrival_time}"
      puts "    Duration: #{connection.duration} minutes"
      puts "    Fares:"
      connection.fares.each do |klass, fare|
        puts "      Class: #{klass}, Price: #{fare[:value]} #{fare[:currency]}"
      end
      puts ""
    end
  end
  puts "Cheapest Route: #{search.cheapest_route.id}"
  puts "Quickest Route: #{search.quickest_route.id}"
end

display_search
