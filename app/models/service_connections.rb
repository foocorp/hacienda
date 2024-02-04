# == Schema Information
#
# Table name: service_connections
#
#  userid          :integer
#  webservice_url  :string(255)
#  remote_key      :string(255)
#  remote_username :string(255)
#  forward         :integer          default(1)
#
class ServiceConnections < ApplicationRecord
end
