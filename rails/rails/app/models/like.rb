class Like < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track
  belongs_to :user
end
