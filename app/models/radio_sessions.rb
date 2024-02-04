# == Schema Information
#
# Table name: radio_sessions
#
#  username :string(64)       default(""), not null, primary key
#  session  :string(32)       default(""), not null, primary key
#  url      :string(255)
#  expires  :integer          default(0), not null
#
class RadioSessions < ApplicationRecord
end
