class ReportsController < ApplicationController
  before_filter :require_admin, only: [:index]
  before_filter :require_login

  def index
    if params[:event_id]
      # todo
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end
end
