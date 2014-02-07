class Notification
  attr_reader :commit

  def initialize(commit)
    @commit = commit
  end

  def deliver
    client = HipChat::Client.new(api_token)
    client[room].send('Go Review Go', body, color: color)
  end

  private

  def api_token
    ENV["HIPCHAT_API_TOKEN"]
  end

  def room
    ENV["HIPCHAT_ROOM"]
  end

  def body
    "Commit <a href='#{commit.github_url}'>#{commit.sha_short}</a> by <a href='#{commit.author.github_url}'>#{commit.author.username}</a> is #{commit.status}"
  end

  COLORS = {
    "rejected" => "red",
    "passed"   => "yellow",
    "accepted" => "green"
  }

  def color
    COLORS.fetch(commit.status)
  end
end
