class RoboscoutQueryPerson < ApplicationRecord
  belongs_to :roboscout_query
  belongs_to :person
end
