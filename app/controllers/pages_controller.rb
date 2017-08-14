class PagesController < ApplicationController
  def home
  end
  
  def doc
  end
  
  def configuration_panel
    @twitter_consumer_key_value = Setting.twitter_consumer_key
    @twitter_consumer_secret_value = Setting.twitter_consumer_secret
  end
end
