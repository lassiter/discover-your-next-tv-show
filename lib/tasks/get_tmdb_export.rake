require "pry"
require 'zlib'
require 'stringio'

namespace :get_tmdb_export do  
  desc "TODO"
  task people: :environment do
  end

  desc "Download daily export from TMDB and update"
  task shows: :environment do
      # Get daily export
      response = get_data_from_TMDB("tv_series_ids")
      File.readlines(response).each do |line|
        parsed_line = JSON.parse(line)
        if TvShow.where(id: parsed_line["id"]).exists?
          update_record(TvShow, parsed_line["id"], parsed_line)
        else
          s = TvShow.new(id: parsed_line["id"], title: parsed_line["original_name"], popularity: parsed_line["popularity"])
          unless s.save
            Rails.logger.error "[rake get_tmdb_export] Update Error for TvShow, #{s} did not save."
          end
        end
      end
  end

  desc "TODO"
  task keywords: :environment do
  end

  desc "TODO"
  task production_companies: :environment do
  end

  desc "TODO"
  task networks: :environment do
  end

  def update_record(klass, id, parsed_line)
    record = klass.find(id)
    parsed_line.each do |key, value|
      record.update_attribute(key, value) if record[key] !== value
    end
  end

  def get_data_from_TMDB(type)
    Dir.mkdir("tmp/tmdb_exports") unless File.directory?("tmp/tmdb_exports")
    # need to wait on file to be created
    # binding.pry
    # sh `cd tmp/tmdb_exports && curl http://files.tmdb.org/p/exports/#{type}_#{Date.today.prev_day.strftime("%d_%m_%Y")}.json.gz?api_key=#{ENV['TMDB_API_KEY']} --output #{type}.json.gz && gunzip #{type}.json.gz && rm #{type}.json.gz`
    uri = URI.parse("http://files.tmdb.org/p/exports/#{type}_#{Date.today.prev_day.strftime("%d_%m_%Y")}.json.gz?api_key=#{ENV['TMDB_API_KEY']}")
    Net::HTTP.start(uri.host, uri.port) do |http|
      resp = http.get(uri.path)
      # Create file latest export for type
      file = File.open(File.join(Dir.pwd, "tmp/tmdb_exports", "#{type}.json"),"w+")
      # Write uncompressed gunzip string to file
      file.write(Zlib::GzipReader.new(StringIO.new(resp.body.to_s)).read)
      file.close
      file
    end
  end
  
end
