require "minitest/autorun"

class LocoSearch < Minitest:Test
  def setup
    file = "search.xml"
    @search = Search.new(file)
  end

  def test_parser_creates_nokogiri_object
    assert_equal doc.class, Nokogiri::HTML::Document
  end

  def test_search_results_exist
    assert_false doc.xpath('//searchresults//searchresult').empty?
  end

  def test_data_parses_all_elements
    #in real life decouple from @search->routes heirarchy
    assert_true @search.routes.connections.first.start_station, 'London St Pancras International'
    assert_true @search.routes.connections.first.train_name, 'Eurostar'
    #add all relevant vars
  end

end

class LocoRoutes < Minitest:Test
  def setup
    file = "search.xml"
    @search = Search.new(file)
    @route = @search.routes.first
  end

  def test_num_connections
    assert_true @route.num_connections, 3
  end

  def test_calculate_layovers
    assert_true @route.connections[1].layover_wait, "NEED TO CALCULATE"
  end

  def test_total_travel_time
    assert_true @route.total_travel_time, 'Need to calculate'
  end

end
