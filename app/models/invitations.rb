# == Schema Information
#
# Table name: invitations
#
#  inviter :string(64)       default(""), not null, primary key
#  invitee :string(64)       default(""), not null, primary key
#  code    :string(32)       default(""), not null, primary key
#
class Invitations < ApplicationRecord
end
