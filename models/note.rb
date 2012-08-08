class Note < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :key
  validates_presence_of :value
end