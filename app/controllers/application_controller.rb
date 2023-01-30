class ApplicationController < ActionController::Base
  def homepage
    render({ :template => "homepage_templates/homepage.html.erb" })
  end
end
