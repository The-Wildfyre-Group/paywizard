class SpreadsheetsController < ApplicationController
  before_action :is_admin
  
  def import
    state, file = params[:state], params[:file] 
    @error_messages = Guide.validate_document(file, state)
    @filename = file.original_filename
    if @error_messages.blank?
      @success = true
      Guide.import(file, state)
    end
    respond_to do |format|
      format.js
      format.html { redirect_to :back }
    end
  end
  
  
end
