# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Pathname.new("tmp/tmdb_exports/tv_series_ids.json").exist?
  puts "Did not find local tv_series_ids.json file, fetching and updating database \nThis normally takes about 6 minutes to process 80,000 + records"
  Rake::Task['rake get_tmdb_export:shows'].invoke()
  sleep 360
else
  puts "Found local tv_series_ids.json file, skipping fetch."
end

puts "Starting to Seed Redis Instant Search\nThis normally takes 3 to 4 minutes"
# Seed Redis Instant Search
SearchSuggestion.seed