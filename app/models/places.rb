# == Schema Information
#
# Table name: places
#
#  location_uri :string(255)      not null, primary key
#  latitude     :float
#  longitude    :float
#  country      :string(2)
#
class Places < ApplicationRecord
end
