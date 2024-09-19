module MostCommonHours
  @hours = []

  def <<(hour)
    @hours << hour
  end

  def max_hours
    count_of_hours = @hours.each_with_object (Hash.new(0)) { |time, hours| hours[time] += 1 }

    count_of_hours.max_by(3) { |_, count| count }
  end

  def most_common_hours
    max_hours = self.max_hours

    max_hours.map.with_index {|v| v[0]}
  end

  def display_hours(hours)
    puts "The most people registered at these hours: #{hours.join(', ')}"
  end
end