class SpreadsheetsController < ApplicationController
  
  def import
    state = params[:state]
    @error_messages = Guide.validate_document(params[:file], state)
    @filename = params[:file].original_filename
    if @error_messages.blank?
      @success = true
      Guide.import(params[:file], state)
    end
    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end
  end
  
  
end
