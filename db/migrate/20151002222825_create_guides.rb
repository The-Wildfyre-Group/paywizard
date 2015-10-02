class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :state
      t.string :name
      t.string :payer_name
      t.boolean :covered
      t.text :coverage_notes
      t.string :current_link
      t.string :old_link
      t.text :link_notes
      t.string :covered_codes
      t.boolean :prior_authorization
      t.text :authorization_notes
      t.string :phone_number
      t.string :fax_number

      t.timestamps
    end
  end
end
