class MainController < ApplicationController
  def index
    @guides = Guide.all
  end
end
