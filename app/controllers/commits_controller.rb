class CommitsController < ApplicationController
  skip_before_filter :verify_authenticity_token # FIXME

  def show
    commit = Commit.find_by!(sha: params[:sha])
    render :json => commit
  end

  def update
    commit = Commit.find_or_create_by(sha: params[:sha])
    commit.update_attributes!(status: params[:status])
    render :json => commit
  end
end
