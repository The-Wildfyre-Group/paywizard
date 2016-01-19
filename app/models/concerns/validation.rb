module Validation
  extend ActiveSupport::Concern
  
  
  module ClassMethods
    # class methods
    
    def validate_document(file, state)
      errors = []
      spreadsheet = open_spreadsheet(file)
      spreadsheet.sheets.each_with_index do |sheet_name, i| 
        sheet = spreadsheet.sheet(sheet_name)
        next if sheet.last_row.nil?
        header = sheet.column(1).collect { |column| column.gsub(" ", "_").downcase unless column.nil?}
        errors << Guide.validate_headers(header, i+1,spreadsheet.sheets.count, sheet_name)
        # p "Errors Blank? #{errors.compact.blank?}"
   #      p "Errors: #{errors.compact}"
        # if errors.compact.blank?
          ((sheet.first_column + 1)..sheet.last_column).each do |i|
            model_hash = Hash[[header, sheet.column(i)].transpose].delete_if { |k, v| k.nil? }.except("coverage","published_policies_section", "pa_section", "other_notes_section", "coding", "formulary", "reimbursement", "relationship_to_other_payers" )
            errors << Guide.validate_products_exists(i+1, spreadsheet.sheets.count, model_hash, sheet_name)
            errors << Guide.validate_payer_exists(i+1, spreadsheet.sheets.count, model_hash, sheet_name)
            errors << Guide.validate_booleans(i+1, spreadsheet.sheets.count, model_hash, sheet_name)
            # p "Products: #{model_hash["products_covered"]}"
    #         p "Products Nil? #{model_hash["products_covered"].nil?}"
            model_hash["products_covered"].try(:split, ", ").try(:each) do |product_name|
              without_products_hash = model_hash.except("products_covered").merge(state: state, name: product_name)  
            end
          end
        # end
      end
      errors.compact.count <= 20 ? errors.compact : errors = [] << "Invalid Spreadsheet: The spreadsheet has more than 20 errors. Please check the file and try again." 
    end
  
    def validate_headers(header, sheet_number, sheets, sheet_name)
      correct_header = ["payer", "contact", "phone_number", "fax_number", nil, "coverage", "published_policies_section", "published_policies", "policy_name", "policy_number", "policy_link", "products_covered", "product_codes_covered", "approved_diagnoses", "approved_diagnoses_codes", "age_limitations", "other_limitations", "state_mandate_apply", "major_medical_benefit", "rx_benefit", nil, "pa_section", "pa_required", "pa_form_required", "pa_link", "pa_process", nil, "other_notes_section", "coverage_notes", nil, "coding", "accepted_billing_codes", "bo_modifier", "is_s9433", "coding_link", nil, "formulary", "nutricia_formulary_products", "open_or_closed_formulary", "formulary_exception_allowed", "formulary_form_required", "formulary_link", "formulary_documentation_required", "formulary_process", nil, "reimbursement", "reimbursement_fee_schedule", "reimbursement_link", "product_reimbursement_rate", "reimbursement_methodology", "reimbursement_fees", "other_notes", nil, "relationship_to_other_payers", "relationship_to_wic", "relationship_to_state_medicaid", "relationship_to_other_programs"]
      correct = header.compact.sort == correct_header.compact.sort
      p header.compact.sort
      p correct_header.compact.sort
      if correct == false
        if sheets > 1
          "On sheet #{sheet_name} (sheet #{sheet_number}), column A in your spreadsheet does not match the requirements of the template. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
        else
          "Column A in your spreadsheet does not match the requirements of the template."
        end
      end
    end
    
    def validate_products_exists(sheet_number, sheets, hash, sheet_name)
      if hash["products_covered"].nil?
         "On sheet #{sheet_name}, the 'Products Covered' field is invalid. It is either blank or too few characters to be a Nutricia product. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
      elsif hash["products_covered"].length < 3
        if sheets > 1
          "On sheet #{sheet_name}, the 'Products Covered' field is invalid. It is either blank or too few characters to be a Nutricia product. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
        else
          "The 'Products Covered' field is invalid."
        end
      end
    end
  
    def validate_payer_exists(sheet_number, sheets, hash, sheet_name)
      if hash["payer"].nil?
         "On sheet #{sheet_name}, the 'Payer' field is invalid. It is either blank or too few characters to be a verified payer. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
      elsif hash["payer"].length < 2
        if sheets > 1
          "On sheet #{sheet_name}, the 'Payer' field is invalid. It is either blank or too few characters to be a verified payer. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
        else
          "The 'Payer' field is invalid."
        end
      end
    end
  
    def validate_booleans(sheet_number, sheets, hash, sheet_name)
      array = []
      ["published_policies", "state_mandate_apply", "major_medical_benefit", "rx_benefit", "pa_required", "pa_form_required", "bo_modifier", "is_s9433","formulary_exception_allowed", "formulary_form_required", "formulary_documentation_required","reimbursement_fee_schedule"].each do |boolean_field|
        ["yes", "no", ""].include?(hash[boolean_field].to_s.downcase) ? array << nil : array << boolean_field.gsub("_", " ").titleize
      end
      unless array.compact.count.zero? 
        if sheets > 1
          "On sheet #{sheet_name}, the fields #{array.compact.join(", ")} are invalid. These fields accept 'Yes', 'No', or blank values. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix and re-upload."
        else
          "The fields #{array.compact.join(", ")} are invalid. These fields accept 'Yes', 'No' or blank values. Please fix and re-upload."
        end
      end
    end 
      
  end

  
end

