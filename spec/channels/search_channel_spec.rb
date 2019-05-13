require "rails_helper"
RSpec.describe SearchChannel, :type => :channel do
  subject(:channel) { described_class.new(connection, {}) }

  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
  end

  it "re-broadcasts to my_channel" do
    socket = {:suggestions=>
      ["{\"Id\":85663,\"Title\":\"Game Of Justice\",\"Popularity\":\"0.6\"}",
       "{\"Id\":77420,\"Title\":\"Game Of Clones\",\"Popularity\":\"0.6\"}",
       "{\"Id\":77313,\"Title\":\"Game Payabat﻿H\",\"Popularity\":\"1.482\"}",
       "{\"Id\":75082,\"Title\":\"Game Of Stones\",\"Popularity\":\"1.4\"}",
       "{\"Id\":73381,\"Title\":\"Game Face\",\"Popularity\":\"3.066\"}",
       "{\"Id\":71925,\"Title\":\"Game Maya\",\"Popularity\":\"2.068\"}",
       "{\"Id\":68823,\"Title\":\"Game Risaya เกมริษยา\",\"Popularity\":\"0.6\"}",
       "{\"Id\":68739,\"Title\":\"Game Two\",\"Popularity\":\"2.351\"}",
       "{\"Id\":67734,\"Title\":\"Game Of Homes\",\"Popularity\":\"0.885\"}",
       "{\"Id\":65100,\"Title\":\"Game Of Arms\",\"Popularity\":\"0.6\"}"]}

    expect {
      ActionCable.server.broadcast(
        "SearchChannel", socket
      )
    }.to have_broadcasted_to("SearchChannel").with(socket)
  end
  
end