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
    "Commit #{commit.sha} was #{commit.status}"
  end

  def color
    case commit.status
    when "rejected" then "red"
    when "passed" then "yellow"
    when "accepted" then "green"
    end
  end
end
