# app/serializers/roboscout_query_serializer.rb
class RoboscoutQuerySerializer < ActiveModel::Serializer
  attributes :id, :query, :created_at, :updated_at
end

