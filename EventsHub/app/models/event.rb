class TimeValidator < ActiveModel::Validator
  def validate(record)
    startTime = record.StartHour * 60 + record.StartMinute
    endTime = record.EndHour * 60 + record.EndMinute
    
    if startTime > endTime
      record.errors[:base] << "Starting time is before ending time."
    end
    
  end
end

class Event < ActiveRecord::Base
    validates :Title, length: { in: 3..80 }
    validates :Description, length: { maximum:200 }
    
    validates :Latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :Longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
    
    validates :StartHour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 }
    validates :EndHour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 }
    validates :StartMinute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60 }
    validates :EndMinute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60 }
    
    validates_with TimeValidator
    
    validates :Day, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }
    validates :Month, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12 }
    validates :Year, numericality: { only_integer: true }
    
    validates :Description, :Latitude, :Longitude, :Title, :StartHour, :StartMinute, :EndHour, :EndMinute, presence: true
end
