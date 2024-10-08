# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'
require_relative 'most_common_time'

HOURS = MostCommonTime.new
DAYS = MostCommonTime.new

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = File.read('secret.key').strip

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info.representative_info_by_address(
    address: zip,
    levels: 'country',
    roles: %w[legislatorUpperBody legislatorLowerBody]
  ).officials
rescue StandardError
  'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
end

def phone_in_range?(phone_number)
  phone_number.size == 11 || phone_number.size > 11
end

def invalid_phone_number?(phone_number)
  phone_number.size == 11 && phone_number[0] != '1'
end

def clean_phone_number(number)
  phone_number = number.gsub(/[+-.()\s]/, '')

  return nil if phone_in_range?(phone_number) || invalid_phone_number?(phone_number)

  return true if (phone_number.length == 11) && phone_number[0].eql?('1')

  true if phone_number.length == 10
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def advise_hours
  max_hours = HOURS.most_common

  HOURS.display_hours(max_hours)
end

def give_time_format(date)
  registration_date = date.split[0].split('/').map(&:to_i)
  registration_hour = date.split[1].split(':').map(&:to_i)

  Time.new registration_date[2], registration_date[0], registration_date[1], registration_hour[0], registration_hour[1]
end

def save_hour(time)
  HOURS << time.hour
end

def save_day(time)
  DAYS << time.wday
end

def save_time(date)
  time = give_time_format(date)

  save_hour(time)

  save_day(time)
end

def advise_days
  most_common_days = DAYS.most_common

  DAYS.display_days(most_common_days)
end

def advise_to_boss
  advise_hours

  advise_days
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone_number = clean_phone_number(row[:homephone])

  form_letter = erb_template.result(binding)

  save_time(row[:regdate])

  save_thank_you_letter(id, form_letter)
end

advise_to_boss
