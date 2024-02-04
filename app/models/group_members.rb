# == Schema Information
#
# Table name: group_members
#
#  joined :integer          not null
#  grp    :integer          not null, primary key
#  member :integer          not null, primary key
#
class GroupMembers < ApplicationRecord
end
