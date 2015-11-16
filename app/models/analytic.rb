class Analytic < ActiveRecord::Base
	class_attribute :backend
  	self.backend = AnalyticsRuby

  	def initialize(user, client_id = nil)
      @user = user
      @client_id = client_id
  	end

  	def track_user_creation
    identify
    track(
      {
        user_id: user.id,
        event: 'Create User',
        properties: {
          city_state: user.zip.to_region
        }
      }
    )
  end

  #track sign in to see how many people are online
  def track_user_sign_in
    identify
    track(
      {
        user_id: user.id,
        event: 'Sign In User'
      }
    )
  end

  


end