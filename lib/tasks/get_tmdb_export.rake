require "pry"
require 'zlib'
require 'stringio'
require 'httparty'

namespace :get_tmdb_export do  
  desc "TODO"
  task people: :environment do
  end

  desc "Download daily export from TMDB and update"
  task shows: :environment do
    puts Time.now
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
    puts Time.now
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
      record.update_attribute(key, value) if record[key] != value
    end
  end

  def get_data_from_TMDB(type)
    Dir.mkdir("tmp/tmdb_exports") unless File.directory?("tmp/tmdb_exports")
    # need to wait on file to be created
    # binding.pry

    stop = 8
    current_time = DateTime.now.utc
    if !(7..stop).cover?(current_time) && current_time > stop
      # Outside Export Time
      url = "http://files.tmdb.org/p/exports/#{type}_#{Date.today.strftime("%m_%d_%Y")}.json.gz"
    else
      # During Export 
      url = "http://files.tmdb.org/p/exports/#{type}_#{Date.today.prev_day.strftime("%m_%d_%Y")}.json.gz"
    end
    # sh `cd tmp/tmdb_exports && curl http://files.tmdb.org/p/exports/#{type}_#{Date.today.prev_day.strftime("%m_%d_%Y")}.json.gz --output #{type}.json.gz && gunzip #{type}.json.gz && rm #{type}.json.gz`
    resp = HTTParty.get("http://files.tmdb.org/p/exports/#{type}_#{Date.today.prev_day.strftime("%m_%d_%Y")}.json.gz")
    file = File.open(File.join(Dir.pwd, "tmp/tmdb_exports", "#{type}.json"),"w+")
    # Write uncompressed gunzip string to 
    file.write(Zlib::GzipReader.new(StringIO.new(resp.body.to_s)).read)
    file.close
    file
  end
  
end
