# == Schema Information
#
# Table name: scrobbles
#
#  track      :string(255)      default(""), not null
#  artist     :string(255)      default(""), not null
#  time       :integer          default(0), not null
#  mbid       :string(36)
#  album      :string(255)
#  source     :string(6)
#  rating     :string(1)
#  length     :integer
#  stid       :integer
#  userid     :integer          not null
#  track_tsv  :tsvector
#  artist_tsv :tsvector
#
class Scrobbles < ApplicationRecord
end
