# == Schema Information
#
# Table name: tags
#
#  tag    :string(64)       default(""), not null
#  artist :string(255)      default(""), not null
#  album  :string(255)      default(""), not null
#  track  :string(255)      default(""), not null
#  userid :integer
#
class Tags < ApplicationRecord
end
