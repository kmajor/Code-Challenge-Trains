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
    assert_equal @route.total_travel_time, 'Need to calculate'
  end
end


