# == Schema Information
#
# Table name: user_relationship_flags
#
#  uid1 :integer          not null, primary key
#  uid2 :integer          not null, primary key
#  flag :string(12)       not null, primary key
#
class UserRelationshipFlags < ApplicationRecord
end
