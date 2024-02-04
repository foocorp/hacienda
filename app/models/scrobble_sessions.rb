# == Schema Information
#
# Table name: scrobble_sessions
#
#  sessionid :string(32)       default(""), not null, primary key
#  expires   :integer
#  client    :string(3)
#  userid    :integer
#  api_key   :string(32)
#
class ScrobbleSessions < ApplicationRecord
end
