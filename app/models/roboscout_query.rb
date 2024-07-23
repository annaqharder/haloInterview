class RoboscoutQuery < ApplicationRecord
  has_many :roboscout_query_people
  has_many :people, through: :roboscout_query_people
end
