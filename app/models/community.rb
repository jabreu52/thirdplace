class Community < ActiveRecord::Base
  has_many :community_users
  has_many :users, through: :community_users
end
