require 'httparty'

response = HTTParty.get('https://catfact.ninja/fact')
if response.success?
  fact = response.parsed_response['fact']
  puts "🐱 Случайный факт о котах: #{fact}"
else
  puts "😿 Не удалось получить факт."
end