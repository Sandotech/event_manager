require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'
require_relative 'most_common_hour'

include MostCommonHours

HOURS = MostCommonHours

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = File.read('secret.key').strip

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def clean_phone_number(number)
  valid_number = number.gsub(/[+-.()\s]/, '')

  return nil if valid_number.size < 10 or valid_number.size > 11 or valid_number.size == 11 and valid_number[0] != '1'

  return true if valid_number.length == 11 and valid_number[0].eql? '1'
  
  true if valid_number.length == 10
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def better_hours_to_ads
  max_hours = HOURS.most_common_hours

  HOURS.display_hours(max_hours)
end

def give_time_format(date)
  registration_date = date.split[0].split('/').map(&:to_i)
  registration_hour = date.split[1].split(':').map(&:to_i)

  date = Time.new registration_date[2], registration_date[0], registration_date[1], registration_hour[0], registration_hour[1]

  HOURS << date.hour
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

  give_time_format(row[:regdate])

  save_thank_you_letter(id,form_letter)
end

better_hours_to_ads