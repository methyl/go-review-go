class PushesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    push = Push.new(JSON.parse(params[:payload])).create_commits
    head :ok
  end
end