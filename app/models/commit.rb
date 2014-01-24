class Commit < ActiveRecord::Base
  validates :status, inclusion: %w(accepted passed rejected)
end
