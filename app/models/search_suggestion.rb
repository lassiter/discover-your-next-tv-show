class SearchSuggestion < ApplicationRecord
  belongs_to :search

  def self.seed
    t1 = Time.now
    $redis.flushdb
    klasses = [TvShow]
    klasses.each do |klass|
      seed_klass(klass)
    end
    t2 = Time.now
    puts t1
    puts t2
    puts "#{t2} - #{t1} = #{t2-t1}"
  end

  private

  def self.seed_klass(klass)
    klass.find_each do |record|
      str = record.title
      parsed_obj = record.as_json.except("created_at", "updated_at").to_json
      1.upto(str.length - 1) do |n|
        prefix = str[0, n]
        $redis.zadd("search-suggestions:#{prefix.downcase}", 1, parsed_obj)
      end
    end
    puts "Finished #{klass.name}"
  end
end
