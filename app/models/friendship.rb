class Friendship < ActiveRecord::Base
    belongs_to :user
    #assigning to the model User in user.rb
    belongs_to :friend, :class_name => "User"
end
