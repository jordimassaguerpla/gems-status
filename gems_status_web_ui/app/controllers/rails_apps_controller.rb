class RailsAppsController < ApplicationController
  # GET /rails_apps
  # GET /rails_apps.json
  def index
    @rails_apps = RailsApp.all
    @checker_types = CheckerType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rails_apps }
    end
  end

end
