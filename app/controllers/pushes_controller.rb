class PushesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_push

  def create
    push = Push.new(JSON.parse(params[:payload])).create_commits
    head :ok
  end

  private

  def authenticate_push
    unless params[:secret].present? && params[:secret] == ENV["PUSH_SECRET"]
      render nothing: true, status: 403
    end
  end
end
