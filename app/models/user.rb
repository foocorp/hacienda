# == Schema Information
#
# Table name: users
#
#  uniqueid         :integer          not null, primary key
#  username         :string(64)       not null
#  password         :string(32)       not null
#  email            :string(255)
#  fullname         :string(255)
#  bio              :text
#  homepage         :string(255)
#  location         :string(255)
#  created          :integer          not null
#  modified         :integer
#  userlevel        :integer          default(0)
#  webid_uri        :string(255)
#  avatar_uri       :string(255)
#  location_uri     :string(255)
#  active           :integer          default(1)
#  laconica_profile :string(255)
#  journal_rss      :string(255)
#  anticommercial   :integer          default(0)
#  public_export    :integer          default(0)
#  openid_url       :string(100)
#  receive_emails   :integer          default(1)
#
class User < ApplicationRecord
	def to_param  # overridden
		username
	  end
end
