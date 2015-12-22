class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def current_user
    @current_user ||= User.find_by_authentication_token(cookies[:authentication_token]) if cookies[:authentication_token]
  end
  
  def states
    Guide.pluck(:state)
  end
  
  def all_states
    ["Alabama", "Alaska", "Arizona","Arkansas" ,"California" ,"Colorado" ,"Connecticut" ,"Delaware" ,"Florida" ,"Georgia" ,"Hawaii" ,"Idaho" ,"Illinois","Indiana" ,"Iowa" ,"Kansas" ,"Kentucky" ,"Louisiana" ,"Maine" ,"Maryland" ,"Massachusetts" ,"Michigan" ,"Minnesota" ,"Mississippi" ,"Missouri" ,"Montana","Nebraska" ,"Nevada" ,"New Hampshire" ,"New Jersey","New Mexico" ,"New York","North Carolina" ,"North Dakota" ,"Ohio" ,"Oklahoma" ,"Oregon" ,"Pennsylvania","Rhode Island" ,"South Carolina" ,"South Dakota" ,"Tennessee" ,"Texas" ,"Utah","Vermont" ,"Virginia" ,"Washington" ,"West Virginia" ,"Wisconsin" ,"Wyoming"]
  end
  
  def payer_names
    Guide.pluck(:payer)
  end
  
  def products
    Guide.pluck(:name)
  end
  
   helper_method :current_user, :states, :payer_names, :products, :all_states
  
  
end

