# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  Users = {"anerian" => "anerian-rocks"}.freeze
  before_filter :authenticate

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def secret
    render :text => "Password Required!"
  end 

private
  def authenticate
    realm = "Coffee ME"
    authenticate_or_request_with_http_digest(realm) do |name|
      Users[name]
    end
  end 
end
