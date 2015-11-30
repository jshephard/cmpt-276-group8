class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_page, only: [:index]
  before_filter :require_login, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    if request.format.json?
      scope = Event
      
      # Don't include events that have already ended
      # hack: timezones need to be implemented.
      scope = scope.where('"EndDate" >= ?', Time.now.in_time_zone('Pacific Time (US & Canada)').to_date)
      if params[:user_id]
        scope = scope.where('"user_id" = ?', params[:user_id])
      end

      if logged_in?
        # An administrator can always see private events.
        if !current_user.is_administrator?
          scope = scope.where('("id_private" != ? OR "user_id" = ?)', true, current_user.id)

          @events = Event.joins('INNER JOIN "friendships" ON "friendships"."approved" = \'t\' AND "friendships"."user_id" = "events"."user_id"').
            where('"friendships"."user_id" = ? OR "friendships"."friend_id" = ?', current_user.id, current_user.id).
            where('"id_private" = ?', true)

          @events = @events.union(Event.joins('INNER JOIN "friendships" ON "friendships"."approved" = \'t\' AND "friendships"."user_id" = ' + current_user.id.to_s).
            where('"friendships"."user_id" = "events"."user_id" OR "friendships"."friend_id" = "events"."user_id"').
            where('"id_private" = ?', true))
        end
      else
        scope = scope.where('"id_private" != ?', true)
      end

      if params[:lat_ne] and params[:long_ne]
        # Request from events map
        
        # How many days into future to look for events
        range = Time.now + 7.days
        if params[:day_range]
          range = (Time.now + params[:day_range].to_i.days);
        end
        scope = scope.where('"EndDate" < ? OR "StartDate" < ?', range, range)

        scope = scope.where('("Latitude" <= ? AND "Latitude" >= ?) AND ("Longitude" <= ? AND "Longitude" >= ?)',
            params[:lat_ne], params[:lat_sw], params[:long_ne], params[:long_sw])
        @events = @events.nil? ? scope.all : @events.union(scope)
      else
        # Request from events index
        @events = @events.nil? ? scope.page(@page) : @events.union(scope).page(@page)
      end
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if !@event.nil? and @event.id_private
      if !logged_in?
        redirect_to root_path, alert: "You don't have permission to view this event."
        return
      elsif current_user.is_administrator?
        return # Administrators can view all events
      end

      # Check for existence of friendship
      friendship = Friendship.find_by(user_id: @event.user_id)
      if !friendship.nil? and friendship.approved and friendship.user_id != current_user.id and friendship.friend_id != current_user.id
        redirect_to root_path, alert: "You don't have permission to view this event."
        return
      end

      friendship = Friendship.find_by(user_id: current_user.id)
      if !friendship.nil? and friendship.approved and friendship.user_id != @event.user.id and friendship.friend_id != @event.user.id
        redirect_to root_path, alert: "You don't have permission to view this event."
        return
      end
    end
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
    else
      # Guests can not create private events.
      @event.id_private = false;
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
      params.require(:event).permit(:Title, :Description, :Address, :Latitude, :Longitude, :Category, :StartDate, :StartTime, :EndDate, :EndTime, :id_private)
    end
end
