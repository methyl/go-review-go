class Commit < ActiveRecord::Base
  validates :sha, format: /[0-9a-f]{40}/
  validates :status, inclusion: %w(accepted passed rejected)

  def to_param
    sha
  end
end
