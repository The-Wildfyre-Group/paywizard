class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def states
    ["Texas", "New York", "Florida", "Georgia", "Illinois", "Ohio", "North Carolina", "Pennsylvania", "Michigan", "New Jersey"]
  end
  
  def payer_names
    ["Aetna", "BlueCross", "WIC", "United Health", "Kaiser"]
  end
  
  def products
    ["Neocate Infant", "Neocate Junior", "Ketocal", "Duocal", "Liquigen"]
  end
  
   helper_method :states, :payer_names, :products
  
  
end
