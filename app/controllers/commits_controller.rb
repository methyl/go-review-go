class CommitsController < ApplicationController
  skip_before_filter :verify_authenticity_token # FIXME

  def index
    @commits = Commit.master
    respond_to do |format|
      format.html
      format.json { render :json => @commits }
      format.text { render :index }
    end
  end

  def all
    @commits = Commit.scoped
    respond_to do |format|
      format.html
      format.json { render :json => @commits }
      format.text { render :index }
    end
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

  def show
    commit = Commit.find_by_sha(params[:id])
    respond_to do |format|
      format.json { render :json => commit }
    end
  end

  def update
    commit = Commit.find_or_create_by(sha: params[:id])
    commit.update_attributes!(status: params[:status])
    Notification.new(commit).deliver
    respond_to do |format|
      format.html { redirect_to pending_commits_path }
      format.json { render :json => commit }
    end
  end
end
