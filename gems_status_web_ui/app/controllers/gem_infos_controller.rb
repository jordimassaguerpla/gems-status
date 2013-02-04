class GemInfosController < ApplicationController
  # GET /gem_infos
  # GET /gem_infos.json
  def index
    @gem_infos = GemInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gem_infos }
    end
  end
end
