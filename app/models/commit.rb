class Commit < ActiveRecord::Base
  validates :sha, format: /[0-9a-f]{40}/
  validates :status, inclusion: %w(accepted passed rejected), allow_nil: true

  def to_param
    sha
  end

  def self.pending
    where(status: nil)
  end
end
