class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def states
    ["Maryland", "Georgia", "Louisiana", "California", "Texas"]
  end
  
  def payer_names
    ["Aetna", "BlueCross", "Wellpoint", "United Health", "Kaiser"]
  end
  
  def products
    ["Tylenol", "Albuterol", "Adderall", "Acetaminophen", "Ibuprofen"]
  end
  
   helper_method :states, :payer_names, :products
  
  
end
