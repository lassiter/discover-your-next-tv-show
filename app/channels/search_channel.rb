
class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'SearchChannel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def search(data)
    results = $redis.zrevrange("search-suggestions:#{data["search_value"].downcase}", 0, 9).map(&:titleize)
    socket = { suggestions: results }
    SearchChannel.broadcast_to('SearchChannel', socket)
  end
  

  
end
