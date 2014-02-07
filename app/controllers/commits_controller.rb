class CommitsController < ApplicationController
  skip_before_filter :verify_authenticity_token # FIXME

  def show
    commit = Commit.find_by_sha(params[:id])
    render :json => commit
  end

  def update
    commit = Commit.find_or_create_by(sha: params[:id])
    commit.update_attributes!(status: params[:status])
    render :json => commit
    Notification.new(commit).deliver
  end

  def pending
    @commits = Commit.master.pending
    render json: @commits
  end
end
