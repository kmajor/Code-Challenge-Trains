require 'nokogiri'
require 'pry'
require 'date'

class Search
  attr_accessor :routes
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
    search_info = Array.new
    search_results.each do |result|
      connections = Array.new
      result_id = result.id.text
      result.connections.connection.each do |xml_connection|
        connection = Connection.build_from_xml(xml_connection)
        connections << connection
      end
    @routes << Route.new(connections: connections)
    end
  end

end

class Route
  def initialize(args)
    @connections = args[:connections]
    calculate_layovers unless @connections.count < 2
  end

  def num_connections
    @connections.count
  end

  def calculate_layovers
    @connections.each_cons(3) do |prev_conn, curr_conn, next_conn|
      continue if prev_conn.nil?
      curr_conn.layover_wait = curr_conn.departure_time - prev_conn.arrival_time
    end
  end

  def total_travel_time
    @connections.last.arrival_time - @connections.first.departure_time
  end

end


class Connection
  attr_accessor :layover_wait, :arrival_time, :departure_time
  def initialize(args)
    @start_station = args[:start]
    @finish_station = args[:finish]
    @departure_time = args[:departure_time]
    @arrival_time = args[:arrival_time]
    @train_name = args[:train_name]
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

  def connection_fares (fare_data)
    fares = {}
    fare_data.each do |one_fare|
      fare_class = one_fare.children[1].text
      fares[fare_class][:currency] = one_fare.price.currency.text.to_f
      fares[fare_class][:value] =  fare_amount = one_fare.price.value.text.to_f
    end
  end

  def duration
    @arrival_time - @departure_time
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

search = Search.new({file: 'search.xml'})
puts search
