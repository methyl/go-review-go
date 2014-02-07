class CommitsController < ApplicationController
  skip_before_filter :verify_authenticity_token # FIXME

  def show
    commit = Commit.find_by_sha(params[:id])
    respond_to do |format|
      format.json { render :json => commit }
    end
  end

  def update
    commit = Commit.find_or_create_by(sha: params[:id])
    commit.update_attributes!(status: params[:status])
    render :json => commit
    Notification.new(commit).deliver
  end

  def pending
    @commits = Commit.master.pending
    respond_to do |format|
      format.html
      format.json { render :json => @commits }
      format.text { render :index }
    end
  end

  def rejected
    @commits = Commit.master.rejected
    respond_to do |format|
      format.html
      format.json { render :json => @commits }
      format.text { render :index }
    end
  end
end
