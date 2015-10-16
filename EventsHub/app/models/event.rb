class Event < ActiveRecord::Base
    validates :Title, length: { maximum:20 }
    validates :Description, length: { maximum:140 }
    validates :Description, :Latitude, :Longitude, :Title, presence: true
end
