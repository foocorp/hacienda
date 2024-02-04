# == Schema Information
#
# Table name: countries
#
#  country      :string(2)        not null, primary key
#  country_name :string(200)
#  wikipedia_en :string(120)
#
class Countries < ApplicationRecord
end
