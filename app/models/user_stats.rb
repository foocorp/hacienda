# == Schema Information
#
# Table name: user_stats
#
#  userid         :integer          not null, primary key
#  scrobble_count :integer          not null
#
class UserStats < ApplicationRecord
end
