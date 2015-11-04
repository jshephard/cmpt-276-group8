class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :description, presence: true
  validates :event, presence: { message: 'does not exist' }
  validates :user, presence: true
end
