class Repo < ActiveRecord::Base
  validates :owner, presence: true
  validates :name, presence: true

  def full_name
    "#{owner}/#{name}"
  end

  def self.unknown
    @unknown ||= Repo.new(owner: "unknown", name: "unknown")
  end
end
