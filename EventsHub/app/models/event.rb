class TimeValidator < ActiveModel::Validator
  def initialize(event)
    @event = event
  end
  
  def validate
    startTime = @event.StartHour * 60 + @event.StartMinute
    endTime = @event.EndHour * 60 + @event.EndMinute
    dateCheck = @event.StartDay == @event.EndDay && @event.StartMonth == @event.EndMonth && @event.StartYear == @event.EndYear
    
    if startTime >= endTime && dateCheck
      @event.errors[:base] << "Starting time is before or is the same as the ending time."
    end
    
  end
end

class DayValidator < ActiveModel::Validator
  def initialize(event)
    @event = event
  end
  
  def validate
    checkMonthYear = @event.StartMonth == @event.EndMonth && @event.StartYear == @event.EndYear
    
    if @event.StartDay > @event.EndDay && checkMonthYear
      @event.errors[:base] << "Starting day is before ending day"
    end
    
  end
end

class MonthValidator < ActiveModel::Validator
  def initialize(event)
    @event = event
  end
  
  def validate
    checkYear = @event.StartYear == @event.EndYear
    
    if @event.StartMonth > @event.EndMonth && checkYear
      @event.errors[:base] << "Starting month is before ending month"
    end
  end
end

class YearValidator < ActiveModel::Validator
  def initialize(event)
    @event = event
  end
  
  def validate
    if @event.StartYear > @event.EndYear
      @event.errors[:base] << "Starting year is before ending year"
    end
  end
end

class Event < ActiveRecord::Base
    belongs_to :user
    
    validates :Title, length: { in: 3..80 }
    validates :Description, length: { maximum:200 }
    
    validates :Latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :Longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
    
    validates :StartHour, numericality: { greater_than_or_equal_to: 0, less_than: 24 }
    validates :EndHour, numericality: { greater_than_or_equal_to: 0, less_than: 24 }
    validates :StartMinute, numericality: { greater_than_or_equal_to: 0, less_than: 60 }
    validates :EndMinute, numericality: { greater_than_or_equal_to: 0, less_than: 60 }
    
    validate do |event|
      TimeValidator.new(event).validate
    end
    
    validates :StartDay, numericality: { greater_than: 0, less_than_or_equal_to: 31 }
    validates :StartMonth, numericality: { greater_than: 0, less_than_or_equal_to: 12 }
    validates :EndDay, numericality: { greater_than: 0, less_than_or_equal_to: 31 }
    validates :EndMonth, numericality: { greater_than: 0, less_than_or_equal_to: 12 }
    
    validate do |event|
      DayValidator.new(event).validate
      MonthValidator.new(event).validate
      YearValidator.new(event).validate
    end
    
    validates :Title, :Description, presence: true
    validates :Latitude, :Longitude, presence: true
    validates :StartHour, :StartMinute, :EndHour, :EndMinute, presence: true
    validates :StartDay, :StartMonth, :StartYear, :EndDay, :EndMonth, :EndYear, presence: true
end
