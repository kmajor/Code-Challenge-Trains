require "minitest/autorun"
require "./parser"

class LocoSearch < MiniTest::Test
  def setup
    file = "search.xml"
    @search = Search.new({file: file})
  end

  def test_parser_creates_nokogiri_object
    assert_equal @search.doc.class, Nokogiri::HTML::Document
  end

  def test_search_results_exist
    assert_equal @search.doc.xpath('//searchresults//searchresult').empty?, false
  end

  def test_data_parses_all_elements
    #in real life decouple from @search->routes heirarchy
    assert_equal @search.routes.first.connections.first.start_station, 'London St Pancras International'
    assert_equal @search.routes.first.connections.first.train_name, 'Eurostar'
    #add all relevant vars
  end

  def test_quickest_route
    assert_equal @search.quickest_route, @search.routes[1]
  end

  def test_cheapest_route
    assert_equal @search.cheapest_route,  @search.routes[2]
  end

end

class LocoRoutes < MiniTest::Test
  def setup
    file = "search.xml"
    @search = Search.new({file: file})
    @route = @search.routes.first
  end

  def test_num_connections
    assert_equal @route.num_connections, 2
  end

  def test_calculate_layovers
    assert_equal @route.connections[1].layover_wait, 75
  end

  def test_total_travel_time
    assert_equal @route.total_travel_time, 594
  end

  def test_id_exists
    assert_equal @route.id, 'F4S1DS'
  end

end

class LocoConnections < MiniTest::Test
  def setup
    file = "search.xml"
    @search = Search.new({file: file})
    @route = @search.routes.first
    @connection = @route.connections.first
  end

  def test_basic_variables_populate
    assert_equal @connection.train_name, "Eurostar"
    assert_equal @connection.start_station, "London St Pancras International"
    #in real life add all vars
  end

  def test_duration
    assert_equal @connection.duration, 138
  end

  def test_fares
    assert_equal @connection.fares.class, Hash
    assert_equal @connection.fares.count, 2
    assert_equal @connection.fares['Standard Class'][:value], 79.0
  end
end
