class Repo < ActiveRecord::Base
  validates :owner, presence: true
  validates :name, presence: true

  def full_name
    "#{owner}/#{name}"
  end
end
