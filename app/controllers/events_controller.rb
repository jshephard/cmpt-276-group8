class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_page, only: [:index]

  # GET /events
  # GET /events.json
  def index
    # We're gonna use json to load events in the background
    if request.format.json?
      # todo: cleanup
      if params[:lat_ne] and params[:long_ne]
        if params[:user_id]
          @events = Event.where("user_id = ? AND (latitude <= ? AND latitude >= ?) AND (longitude <= ? AND longitude >= ?)", 
            params[:user_id], params[:lat_ne], params[:lat_sw], params[:long_ne], params[:long_sw])
        else
          @events = Event.where("(latitude <= ? AND latitude >= ?) AND (longitude <= ? AND longitude >= ?)", 
            params[:lat_ne], params[:lat_sw], params[:long_ne], params[:long_sw])
        end
      else
        if params[:user_id]
          @events = Event.where(user_id: params[:user_id]).page(@page)
        else
          @events = Event.page(@page)
        end
      end
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    
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
    @events = Event.where(user: params[:id])
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:Title, :Description, :Address, :Latitude, :Longitude, :Category, :StartDay, :StartMonth, :StartYear, :EndDay, :EndMonth, :EndYear, :StartHour, :StartMinute, :EndHour, :EndMinute)
    end
end
