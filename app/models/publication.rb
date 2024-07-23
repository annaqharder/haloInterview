class Publication < ApplicationRecord
  has_many :person_publications
  has_many :people, through: :person_publications
end
