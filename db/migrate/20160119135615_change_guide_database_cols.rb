class ChangeGuideDatabaseCols < ActiveRecord::Migration
  def change
    rename_column :guides, :codes_covered, :product_codes_covered
    add_column :guides, :approved_diagnoses_codes, :text
    add_column :guides, :other_notes, :text
    
  end
end
