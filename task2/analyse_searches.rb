require "csv"
require "pry"

class Search
  attr_accessor :origin, :destination, :duration, :count, :sum, :min, :max
  def initialize(args)
    @origin = args[:origin]
    @destination = args[:destination]
    @count = args[:count]
    duration = duration_in_seconds(args[:duration])
    @sum = @min = @max = duration
  end

  def mean
    @sum / @count
  end

  def name
    @origin + " to " + @destination
  end

  def aggregate_result(search_duration)
    duration = duration_in_seconds(search_duration)
    @sum += duration
    @count += 1
    if @min > duration
      @min = duration
    end

    if @max < duration
      @max = duration
    end
  end

  def duration_in_seconds(search_duration)
    hours, minutes, seconds = search_duration.split(":")
    hours.to_i * 60*60 + minutes.to_i * 60 + seconds.to_f
  end
end


class Parser
  def self.parse_csv(file)
    searches = Array.new
    CSV.foreach(file) do |row|
      origin = row[0]
      destination = row[1]
      duration = row[2]
      search_args={
        origin: origin,
        destination: destination,
        duration: duration,
        count: 1,
      }

      if existing = searches.find_index {|search| search.origin == origin && search.destination == destination}
        searches[existing].aggregate_result(duration)
      else
        searches << Search.new(search_args)
      end
    end
  searches
  end
end

searches = Parser.parse_csv("searches.csv")

puts <<-HTML
<html>
  <head>
    <meta charset='utf-8'>
  </head>
  <body>
    <table>
      <tr>
        <th>Search</th>
        <th>Count</th>
        <th>Mean duration</th>
        <th>Min duration</th>
        <th>Max duration</th>
      </tr>
HTML
searches.sort_by { |search| search.count }.reverse.each do |search|
  puts "<tr>"
  puts "<td>#{search.name}</td>"
  puts "<td>#{search.count}</td>"
  puts "<td>#{search.mean.round(1)}s</td>"
  puts "<td>#{search.min.round(1)}s</td>"
  puts "<td>#{search.max.round(1)}s</td>"
  puts "</tr>"
end

puts "</table></body></html>"
