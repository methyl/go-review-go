class Push
  def initialize(payload)
    @payload = payload
  end

  def create_commits
    @payload["commits"].each do |commit_payload|
      create_commit(commit_payload)
    end
  end

  def create_commit(payload)
    Commit.find_or_create_by(sha: payload["id"])
  end
end
