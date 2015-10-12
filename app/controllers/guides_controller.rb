class GuidesController < ApplicationController
  
  
  def index
    @guide = Guide.where(state: params[:state], payer_name: params[:payer_name], name: params[:name] ).last
  end
  
  def new
    @guide = Guide.new
    
  end
  
  def create
    @guide = Guide.new(guide_params)
    if @guide.save
      redirect_to root_path
    else
      
    end
  end
  
  protected
  
  def guide_params
    params.require(:guide).permit(:state, :name, :contact, :medicaid_ffs, :managed_care_medicaid, :wic, :private_commercial, :medical_food_policy, :formulary_review_date, :formulary, :reimbursement_methodology, :payer_name, :current_link, :link_notes, :phone_number, :fax_number)
  end
  
end