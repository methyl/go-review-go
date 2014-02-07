class Person < ActiveRecord::Base
  validates :email, presence: true

  def github_url
    "https://github.com/#{username}"
  end

  def self.unknown
    @unknown ||= Person.new(email: "unknown@example.com", name: "Unknown", username: "unknown")
  end
end
