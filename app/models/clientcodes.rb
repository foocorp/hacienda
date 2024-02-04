# == Schema Information
#
# Table name: clientcodes
#
#  code :string(3)        default(""), not null, primary key
#  name :string(32)
#  url  :string(256)
#  free :string(1)        default("N")
#
class Clientcodes < ApplicationRecord
end
