class GuidesController < ApplicationController
  
  
  def index
    @guide = Guide.where(state: params[:state], payer_name: params[:payer_name], name: params[:name] ).last
  end
end
