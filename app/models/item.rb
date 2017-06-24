class Item < ApplicationRecord
  #association
  belongs_to :todo

  #validations
  validates_presence_of :name
end
