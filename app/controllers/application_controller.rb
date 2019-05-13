class ApplicationController < ActionController::API
  Tmdb::Api.key(ENV['TMDB_API_KEY'])
end
