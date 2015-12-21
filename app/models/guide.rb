class Guide < ActiveRecord::Base
  extend FriendlyId
  friendly_id :use_for_slug, use: [:slugged, :finders]
  before_update :update_slug
  
  validates :state, presence: true
  validates :name, presence: true
  validates :payer, presence: true

  
  def use_for_slug
    existing_guide = Guide.where(name: self.name, state: self.state, payer: self.payer)
    if existing_guide.present?
      "#{name} for #{payer} in #{state} #{existing_guide.count}"
    else
      "#{name} for #{payer} in #{state}"
    end
  end
  
  def update_slug
    # if (first_name_changed? || last_name_changed?)
  #     existing_user = minus_self.where('first_name = ?', self.first_name).where('last_name = ?', self.last_name)
  #     if existing_user.present?
  #       update_column(:slug, "#{ApplicationController.helpers.to_slug(first_name, last_name, (existing_user.count + 1))}")
  #     else
  #       update_column(:slug, "#{ApplicationController.helpers.to_slug(first_name, last_name)}")
  #     end
  #   end
  end
  
  def self.make_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |guide|
        csv << guide.attributes.values_at(*column_names)
      end
    end
  end
  
  
  def self.import(file, state)
    spreadsheet = open_spreadsheet(file)
    spreadsheet.sheets.each_with_index do |sheet_name, i|
      sheet = spreadsheet.sheet(sheet_name)
      header = sheet.column(1).collect { |column| column.gsub(" ", "_").downcase unless column.nil?}
      ((sheet.first_column + 1)..sheet.last_column).each do |i|
        model_hash = Hash[[header, sheet.column(i)].transpose].delete_if { |k, v| k.nil? }.except("coverage","published_policies_section", "pa_section", "other_notes_section", "coding", "formulary", "reimbursement", "relationship_to_other_payers" )
        model_hash["products_covered"].split(", ").each do |product_name|
          without_products_hash = model_hash.except("products_covered").merge(state: state, name: product_name)
          object = Guide.where(state: state, name: product_name, payer: model_hash["payer"])
          if object.present? 
             object.first.update_attributes(without_products_hash)
             guide = object.first
          else
             guide = Guide.create!(without_products_hash.merge(id: Guide.last.try(:id).to_i + 1))
           end
          guide.update_attributes(
            published_policies: model_hash["published_policies"].to_s.downcase == "yes" ? true : (model_hash["published_policies"].to_s.downcase == "no" ? false : nil),
            state_mandate_apply: model_hash["state_mandate_apply"].to_s.downcase == "yes" ? true : (model_hash["state_mandate_apply"].to_s.downcase == "no" ? false : nil),
            major_medical_benefit: model_hash["major_medical_benefit"].to_s.downcase == "yes" ? true : (model_hash["major_medical_benefit"].to_s.downcase == "no" ? false : nil),
            rx_benefit: model_hash["rx_benefit"].to_s.downcase == "yes" ? true : (model_hash["rx_benefit"].to_s.downcase == "no" ? false : nil),
            pa_required: model_hash["pa_required"].to_s.downcase == "yes" ? true : (model_hash["pa_required"].to_s.downcase == "no" ? false : nil),
            pa_form_required: model_hash["pa_form_required"].to_s.downcase == "yes" ? true : (model_hash["pa_form_required"].to_s.downcase == "no" ? false : nil),
            bo_modifier: model_hash["bo_modifier"].to_s.downcase == "yes" ? true : (model_hash["bo_modifier"].to_s.downcase == "no" ? false : nil),
            is_s9433: model_hash["is_s9433"].to_s.downcase == "yes" ? true : (model_hash["is_s9433"].to_s.downcase == "no" ? false : nil),
            formulary_exception_allowed: model_hash["formulary_exception_allowed"].to_s.downcase == "yes" ? true : (model_hash["formulary_exception_allowed"].to_s.downcase == "no" ? false : nil),
            formulary_form_required: model_hash["formulary_form_required"].to_s.downcase == "yes" ? true : (model_hash["formulary_form_required"].to_s.downcase == "no" ? false : nil),
            formulary_documentation_required: model_hash["formulary_documentation_required"].to_s.downcase == "yes" ? true : (model_hash["formulary_documentation_required"].to_s.downcase == "no" ? false : nil),
            reimbursement_fee_schedule: model_hash["reimbursement_fee_schedule"].to_s.downcase == "yes" ? true : (model_hash["reimbursement_fee_schedule"].to_s.downcase == "no" ? false : nil)
          )
        end
      end
    end
  end
  
  def self.validate_document(file, state)
    errors = []
    spreadsheet = open_spreadsheet(file)
    spreadsheet.sheets.each_with_index do |sheet_name, i|
      sheet = spreadsheet.sheet(sheet_name)
      header = sheet.column(1).collect { |column| column.gsub(" ", "_").downcase unless column.nil?}
      errors << Guide.validate_headers(header, i+1,spreadsheet.sheets.count, sheet_name)
      #return errors.compact if errors.present?
      ((sheet.first_column + 1)..sheet.last_column).each do |i|
        model_hash = Hash[[header, sheet.column(i)].transpose].delete_if { |k, v| k.nil? }.except("coverage","published_policies_section", "pa_section", "other_notes_section", "coding", "formulary", "reimbursement", "relationship_to_other_payers" )
        errors << Guide.validate_products_and_payer_exists(i+1, spreadsheet.sheets.count, model_hash, sheet_name)
        errors << Guide.validate_booleans(i+1, spreadsheet.sheets.count, model_hash, sheet_name)
        model_hash["products_covered"].split(", ").each do |product_name|
          without_products_hash = model_hash.except("products_covered").merge(state: state, name: product_name)  
        end
      end
    end
    errors.compact
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def self.validate_headers(header, sheet_number, sheets, sheet_name)
    correct_header = ["payer", "contact", "phone_number", "fax_number", nil, "coverage", "published_policies_section", "published_policies", "policy_name", "policy_number", "policy_link", "products_covered", "codes_covered", "approved_diagnoses", "age_limitations", "other_limitations", "state_mandate_apply", "major_medical_benefit", "rx_benefit", nil, "pa_section", "pa_required", "pa_form_required", "pa_link", "pa_process", nil, "other_notes_section", "coverage_notes", nil, "coding", "accepted_billing_codes", "bo_modifier", "is_s9433", "coding_link", nil, "formulary", "nutricia_formulary_products", "open_or_closed_formulary", "formulary_exception_allowed", "formulary_form_required", "formulary_link", "formulary_documentation_required", "formulary_process", nil, "reimbursement", "reimbursement_fee_schedule", "reimbursement_link", "product_reimbursement_rate", "reimbursement_methodology", "reimbursement_fees", nil, "relationship_to_other_payers", "relationship_to_wic", "relationship_to_state_medicaid", "relationship_to_other_programs"]
    correct = header.compact.sort == correct_header.compact.sort
    if correct == false
      if sheets > 1
        "On sheet #{sheet_name} (sheet #{sheet_number}), column A in your spreadsheet does not match the requirements of the template. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
      else
        "Column A in your spreadsheet does not match the requirements of the template."
      end
    end
  end
  
  def self.validate_products_and_payer_exists(sheet_number, sheets, hash, sheet_name)
    if hash["products_covered"].nil?
       "On sheet #{sheet_name}, the 'Products Covered' field is invalid. It is either blank or too few characters to be a Nutricia product. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
    elsif hash["products_covered"].length < 3
      if sheets > 1
        "On sheet #{sheet_name}, the 'Products Covered' field is invalid. It is either blank or too few characters to be a Nutricia product. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
      else
        "The 'Products Covered' field is invalid."
      end
    end
    
    if hash["payer"].nil?
       "On sheet #{sheet_name}, the 'Payer' field is invalid. It is either blank or too few characters to be a verified payer. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
    elsif hash["products_covered"].length < 2
      if sheets > 1
        "On sheet #{sheet_name}, the 'Payer' field is invalid. It is either blank or too few characters to be a verified payer. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
      else
        "The 'Payer' field is invalid."
      end
    end
  end
  
  def self.validate_booleans(sheet_number, sheets, hash, sheet_name)
      array = []
      ["published_policies", "state_mandate_apply", "major_medical_benefit", "rx_benefit", "pa_required", "pa_form_required", "bo_modifier", "is_s9433","formulary_exception_allowed", "formulary_form_required", "formulary_documentation_required","reimbursement_fee_schedule"].each do |boolean_field|
        if ["yes", "no", ""].include? hash[boolean_field].to_s.downcase
          array << nil
        else
          array << boolean_field.gsub("_", " ").titleize
        end
      end
      unless array.compact.count.zero? 
        if sheets > 1
          "On sheet #{sheet_name}, the fields #{array.compact.join(", ")} are invalid. These fields accept 'Yes', 'No', or blank values. This spreadsheet has #{sheets} sheet(s). The error may exist on multiple sheets. Please fix an re-upload."
        else
          "The fields #{array.compact.join(", ")} are invalid. These fields accept 'Yes', 'No' or blank values. Please fix an re-upload."
        end
      end
  end
  
  def self.test_render
    ApplicationController.new.render_to_string(
      :template => 'users/index',
      :layout => 'my_layout',
      :locals => { :@guides => @guides }
    )
  end
  
 
  
  
  
  
end
