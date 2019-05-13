require 'rails_helper'

RSpec.describe SearchSuggestion, type: :model do
  it "should have many search suggestions" do
    s = SearchSuggestion.reflect_on_association(:search)
    expect(s.macro).to eq(:belongs_to)
  end
end
