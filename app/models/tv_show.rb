class TvShow < ApplicationRecord
  alias_attribute :original_name, :title
end
