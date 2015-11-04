class ReportsController < ApplicationController
  before_filter :require_admin, only: [:index, :destroy]
  before_filter :require_login
  before_action :set_page, only: [:index]
  before_action :set_report, only: [:destroy]

  def index
    if request.format.json?
      if params[:event_id]
        @reports = Report.where(:event_id => params[:event_id]).page(@page)
      else
        @reports = Report.page(@page)
      end
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_param)
    @report.user_id = current_user.id

    respond_to do |format|
      if @report.save
        format.html { redirect_to root_path, notice: 'Report successfully submitted.' }
        format.json { render json: { :message => 'Report successfully submitted.', :redirect => root_path } }
      else
        format.html { redirect_to root_path, notice: 'Unable to submit report.' }
        format.json { render json: { :errors => @report.errors, :messages => @report.errors.full_messages},
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.delete
    redirect_to reports_path, notice: 'Report deleted.'
  end

  private
    def report_param
      params.require(:report).permit(:description, :event_id)
    end

    def set_report
      if params[:id]
        @report = Report.find_by(id: params[:id])
      end
    end
end
