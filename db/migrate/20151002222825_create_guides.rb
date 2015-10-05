class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :state
      t.string :name
      t.string :contact
      t.string :medicaid_ffs
      t.string :managed_care_medicaid
      t.string :medical_food_policy
      t.date   :formulary_review_date
      t.boolean :formulary
      t.string :reimbursement_methodology
      t.string :payer_name
      t.string :current_link
      t.string :old_link
      t.text :link_notes
      t.string :phone_number
      t.string :fax_number

      t.timestamps
    end
  end
end
