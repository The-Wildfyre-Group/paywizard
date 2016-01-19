class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :state
      t.string :name
      t.string :payer
        
    # contact
      t.string :contact
      t.string :phone_number
      t.string :fax_number
      
    # coverage
      # coverage - published policies
      t.boolean :published_policies
      t.string  :policy_name
      t.string  :policy_number
      t.string  :policy_link
      t.text    :product_codes_covered
      t.text    :approved_diagnoses
      t.text    :approved_diagnoses_codes
      t.text    :age_limitations
      t.text    :other_limitations
      t.boolean :state_mandate_apply
      t.boolean :major_medical_benefit
      t.boolean :rx_benefit
      
      # coverage - PA required
      t.boolean :pa_required
      t.boolean :pa_form_required
      t.string  :pa_link
      t.text    :pa_process
      
      # coverage - other notes
      t.text    :coverage_notes
      
    # coding
      t.text    :accepted_billing_codes
      t.boolean :bo_modifier
      t.boolean :is_s9433
      t.string  :coding_link
      
    # formulary
      t.string  :nutricia_formulary_products
      t.string  :open_or_closed_formulary
      t.boolean :formulary_exception_allowed
      t.boolean :formulary_form_required
      t.string  :formulary_link
      t.boolean :formulary_documentation_required
      t.text    :formulary_process
    
    # reimbursement
      t.boolean :reimbursement_fee_schedule
      t.string  :reimbursement_link
      t.string  :product_reimbursement_rate
      t.text    :reimbursement_specific
      t.text    :reimbursement_methodology
      t.string  :reimbursement_fees
      t.string  :other_notes
      
    
    # relationship to other payers
      t.text :relationship_to_wic
      t.text :relationship_to_state_medicaid
      t.text :relationship_to_other_programs
     
      t.string :slug

      t.timestamps
    end
    add_index :guides, :name
    add_index :guides, :payer
    add_index :guides, :state
    add_index :guides, :slug
  end
end
