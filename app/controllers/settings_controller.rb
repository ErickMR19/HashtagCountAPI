class SettingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def update
    @new_value = params[:new_value].squish
    @setting = params[:setting]
    if @setting == 'twitter_consumer_key' || @setting == 'twitter_consumer_secret'
      Setting[@setting] = @new_value
      # elimina el bearer token si se cambia alguno de los valores, puesto que se ocuparia uno nuevo
      Setting.twitter_bearer_token = ""
    end
  end
end
