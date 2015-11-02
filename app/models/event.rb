

class Event < ActiveRecord::Base
    belongs_to :user
    
    validates :Title, length: { in: 3..80 }
    validates :Description, length: { maximum:200 }
    
    validates :Latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :Longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

    validates :Title, :Description, :Address, presence: true
    validates :Latitude, :Longitude, presence: true
    validates :StartDate, :StartTime, :EndDate, :EndTime, presence: true
    
end
