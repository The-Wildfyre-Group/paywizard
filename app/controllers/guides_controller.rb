class GuidesController < ApplicationController
  before_action :is_admin, except: %w|index show|
  before_action :find_object, only: %w|show edit|
  
  
  def index
    # search
    @states = params[:state].present? ? Guide.where(state: params[:state]) : Guide.all
    @payers = params[:payer].present? ? Guide.where(payer: params[:payer]) : Guide.all
    @names =  params[:name].present? ? Guide.where(name: params[:name]) : Guide.all
    @guide_ids = @states.pluck(:id) & @payers.pluck(:id) & @names.pluck(:id)
    @guides = Guide.where(id: @guide_ids)
    
    if @guides.present?
      # pagination
      @per_page = 5
      @page = params["page"].to_i
      @page_count = (@guides.count / @per_page) + 1
      @paginated_guides = @guides.limit(@per_page).offset(@per_page * [@page - 1, 0].max)
    end
    
    @guide = @guides.last
    respond_to do |format|
      format.html
      format.csv { send_data @guides.make_csv(params) }
      format.xls  #{ send_data @guides.make_csv(col_sep: "\t") }
    end
  end
  
  def new
    @guide = Guide.new
  end
  
  def create
    @guide = Guide.new(guide_params.merge(id: Guide.last.try(:id).to_i + 1))
    if @guide.save
      redirect_to @guide
    else
      render 'new'
    end
  end
    
  def show;end

  def edit;end
  
  def update
    @guide = Guide.friendly.find(params[:id])
    if @guide.update_attributes(guide_params)
      redirect_to @guide 
    else
      render 'edit'
    end
  end
  
  def destroy
    @guide = Guide.find(params[:id])
    @guide.destroy
    redirect_to guides_path
  end
  
  protected
  
  def guide_params
    params.require(:guide).permit(:state, :name, :payer, :contact, :phone_number, :fax_number, :published_policies, :policy_name, :policy_number, :policy_link, :codes_covered, :approved_diagnoses, :age_limitations, :other_limitations, :state_mandate_apply, :major_medical_benefit, :rx_benefit, :pa_required, :pa_form_required, :pa_link, :pa_process, :coverage_notes, :accepted_billing_codes, :bo_modifier, :is_s9433, :coding_link, :nutricia_formulary_products, :open_or_closed_formulary, :formulary_exception_allowed, :formulary_form_required, :formulary_link, :formulary_documentation_required, :formulary_process, :reimbursement_fee_schedule, :reimbursement_link, :product_reimbursement_rate, :reimbursement_specific, :reimbursement_methodology, :reimbursement_fees, :relationship_to_wic, :relationship_to_state_medicaid, :relationship_to_other_programs)
  end
  
  def find_object
     @guide = Guide.friendly.find(params[:id])
  end
  
end


   