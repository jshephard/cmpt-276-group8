class TimeValidator < ActiveModel::Validator
    def initialize(event)
        @event = event
    end

    def validate
        # Have to check for nil, because validation will always run
        if @event.StartTime.nil? or @event.EndTime.nil? or @event.StartDate.nil? or @event.EndDate.nil?
            return
        end
        if @event.StartTime >= @event.EndTime && @event.StartDate == @event.EndDate
            @event.errors[:base] << "Starting time is before or is the same as the ending time."
        end

    end
end


class DateValidator < ActiveModel::Validator
    def initialize(event)
        @event = event
    end

    def validate
        # Have to check for nil, because validation will always run
        if @event.StartTime.nil? or @event.EndTime.nil? or @event.StartDate.nil? or @event.EndDate.nil?
            return
        end
        if @event.StartDate > @event.EndDate
            @event.errors[:base] << "Starting date is before ending date"
        end
    end
end

class Event < ActiveRecord::Base
    belongs_to :user
    has_many :reports, dependent: :destroy
    
    validates :Title, length: { in: 3..80 }
    validates :Description, length: { maximum:200 }
    
    validates :Latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :Longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

    validates :Title, :Description, :Address, presence: true
    validates :Latitude, :Longitude, presence: true
    validates :StartDate, :StartTime, :EndDate, :EndTime, presence: true

    validate do |event|
      TimeValidator.new(event).validate
      DateValidator.new(event).validate
    end
end
