# == Schema Information
#
# Table name: user_relationships
#
#  uid1        :integer          not null, primary key
#  uid2        :integer          not null, primary key
#  established :integer          not null
#
class UserRelationships < ApplicationRecord
end
