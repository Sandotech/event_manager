# frozen_string_literal: true

# This class identifies the most common registration times and days.#
class MostCommonTime
  DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

  def initialize
    @time = []
  end

  def <<(time)
    @time << time
  end

  def count_time
    count_of_time = @time.each_with_object(Hash.new(0)) { |time, hours| hours[time] += 1 }

    count_of_time.max_by(3) { |_, count| count }
  end

  def days
    DAYS.map.with_index.with_object(Hash.new(0)) { |day, index| index[day[0]] += day[1] }
  end

  def most_common
    max_hours = count_time

    max_hours.map { |v| v[0] }
  end

  def display_hours(hours)
    puts "The most people registered at these hours: #{hours.join(', ')}"
  end

  def to_weekday(days)
    days.map { |day| self.days.key day }
  end

  def display_days(days)
    puts "The most people registered at these days: #{to_weekday(days).join(', ')}"
  end
end
