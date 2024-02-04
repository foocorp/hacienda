# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  groupname  :string(64)       not null
#  fullname   :string(255)
#  bio        :text
#  homepage   :string(255)
#  created    :integer          not null
#  modified   :integer
#  avatar_uri :string(255)
#  grouptype  :integer
#  owner      :integer
#
class Groups < ApplicationRecord
end
