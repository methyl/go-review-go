class Person < ActiveRecord::Base
  validates :email, presence: true
end
