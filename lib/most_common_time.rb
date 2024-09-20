module MostCommonTime
  @time = []

  def <<(time)
    @time << time
  end

  def count_time
    count_of_time = @time.each_with_object (Hash.new(0)) { |time, hours| hours[time] += 1 }

    count_of_time.max_by(3) { |_, count| count }
  end

  def most_common
    max_hours = self.count_time

    max_hours.map.with_index {|v| v[0]}
  end

  def display_hours(hours)
    puts "The most people registered at these hours: #{hours.join(', ')}"
  end
end