require 'rails_helper'

RSpec.describe Search, type: :model do
  it "should have many search suggestions" do
    s = Search.reflect_on_association(:search_suggestions)
    expect(s.macro).to eq(:has_many)
  end
end
