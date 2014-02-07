class Commit < ActiveRecord::Base
  belongs_to :repo
  belongs_to :author, class_name: "Person"
  belongs_to :committer, class_name: "Person"

  validates :sha, format: /[0-9a-f]{40}/, uniqueness: true
  validates :status, inclusion: %w(accepted passed rejected), allow_nil: true

  scope :master,   -> { where(master: true) }
  scope :pending,  -> { where(status: nil) }

  def to_param
    sha
  end

  def as_json(options = nil)
    options[:include] ||= [:author, :committer]
    super(options)
  end
end
