class Person < ActiveRecord::Base
  validates :email, presence: true

  def github_url
    "https://github.com/#{username}"
  end
end
