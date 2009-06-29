# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  Users = {"anerian" => "anerian-rocks"}.freeze
  before_filter :digest_authenticate

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def secret
    render :text => "Password Required!"
  end 

private
  def digest_authenticate
    
    if !session[:user_name] or !Users.key?(session[:user_name])

      success = authenticate_or_request_with_http_digest("Coffee ME") do |name|
        @user_name = name
        logger.debug("authenticate user name: #{name.inspect}")
        if Users.key?(name)
          Users[name]
        else
          false
        end
      end

      if success
        session[:user_name] = @user_name
      else
        request_http_digest_authentication("Admin", "Authentication failed")
      end

    end
  end 
end
