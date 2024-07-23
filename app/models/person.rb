class Person < ApplicationRecord
  has_many :roboscout_query_people
  has_many :roboscout_queries, through: :roboscout_query_people
  has_many :person_publications
  has_many :publications, through: :person_publications
end
