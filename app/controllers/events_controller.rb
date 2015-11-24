class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_page, only: [:index]
  before_filter :require_login, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    # We're gonna use json to load events in the background
    if request.format.json?
      # todo: cleanup
      # todo: privacy
      range = Time.now + 7.days
      if params[:day_range]
        range = (Time.now + params[:day_range].to_i.days);
      end

      if params[:lat_ne] and params[:long_ne]
        if params[:user_id]
          @events = Event.where("user_id = ? AND (\"Latitude\" <= ? AND \"Latitude\" >= ?) AND (\"Longitude\" <= ? AND \"Longitude\" >= ?)",
            params[:user_id], params[:lat_ne], params[:lat_sw], params[:long_ne], params[:long_sw]).where('EndDate > ?', DateTime.now).
              where('EndDate < ? OR StartDate < ?', range, range)
        else
          @events = Event.where("(\"Latitude\" <= ? AND \"Latitude\" >= ?) AND (\"Longitude\" <= ? AND \"Longitude\" >= ?)",
            params[:lat_ne], params[:lat_sw], params[:long_ne], params[:long_sw]).where('EndDate > ?', DateTime.now).
              where('EndDate < ? OR StartDate < ?', range, range)
        end
      else
        if params[:user_id]
          @events = Event.where(user_id: params[:user_id]).where('EndDate > ?', DateTime.now).page(@page)
        else
          @events = Event.where('EndDate > ?', DateTime.now).page(@page)
        end
      end
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    #todo: privacy
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    if current_user.is_administrator?
      if @event.nil?
        redirect_to events_path, alert: 'Event does not exist.'
      end
    elsif @event.nil? or @event.user_id != current_user.id
      redirect_to root_path, alert: 'You do not have permission to view this page.'
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    #todo: check limits for users
    
    if logged_in?
      @event.user_id = current_user.id
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /events/user/1
  # GET /events/user/1.json
  def list
    #todo: privacy
    @events = Event.where(user: params[:id]).where('EndDate > ?', DateTime.now)
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if current_user.is_administrator?
        if @event.nil?
          format.html { redirect_to events_path, alert: 'Event does not exist.' }
          format.json { render json: {message: 'Event does not exist.', redirect: events_path }, status: :unprocessable_entity }
          return
        end
      elsif @event.nil? or @event.user_id != current_user.id
        format.html { redirect_to root_path, alert: 'You do not have permission to view this page.' }
        format.json { render json: {message: 'You do not have permission to view this page.', redirect: root_path }, status: :unprocessable_entity }
        return
      end

      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    respond_to do |format|
      if current_user.is_administrator?
        if @event.nil?
          format.html { redirect_to events_path, alert: 'Event does not exist.' }
          format.json { render json: {message: 'Event does not exist.', redirect: events_path }, status: :unprocessable_entity }
          return
        end
      elsif @event.nil? or @event.user_id != current_user.id
        format.html { redirect_to root_path, alert: 'You do not have permission to view this page.' }
        format.json { render json: {message: 'You do not have permission to view this page.', redirect: root_path }, status: :unprocessable_entity }
        return
      end

      @event.destroy
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:Title, :Description, :Address, :Latitude, :Longitude, :Category, :StartDate, :StartTime, :EndDate, :EndTime)
    end
end
