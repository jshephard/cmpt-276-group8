class Event < ActiveRecord::Base
    validates :Title, length: { maximum:20 }
    validates :Title, presence: true
    validates :Description, length: { maximum:140 }
    validates :Description, presence: true
    validates :Latitude, presence: true
    validates :Longitude, presence: true
end
