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
    Commit.find_or_create_by(sha: payload["id"]) do |c|
      c.repo      = repo
      c.author    = find_or_create_person(payload["author"])
      c.committer = find_or_create_person(payload["committer"])
      c.message   = payload["message"]
      c.timestamp = Time.parse(payload["timestamp"])
    end
  end

  def find_or_create_person(payload)
    Person.find_or_create_by(email: payload["email"]) do |p|
      p.name = payload["name"]
      p.username = payload["username"]
    end
  end

  def repo
    Repo.find_or_create_by!(owner: @payload["repository"]["owner"]["name"], name: @payload["repository"]["name"])
  end
end
