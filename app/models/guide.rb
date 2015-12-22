class Guide < ActiveRecord::Base
  extend FriendlyId
  include Validation
  friendly_id :use_for_slug, use: [:slugged, :finders]
  before_update :update_slug
  
  [:state, :name, :payer].each { |col| validates col, presence: true}
  
  def use_for_slug
    existing_guide = Guide.where(name: self.name, state: self.state, payer: self.payer)
    existing_guide.present? ? "#{name} for #{payer} in #{state} #{existing_guide.count}" : "#{name} for #{payer} in #{state}"
  end
  
  def minus_self
    Guide.where.not(id: id)
  end
  
  def update_slug
    if (state_changed? || name_changed? || payer_changed?)
      existing_guide = self.minus_self.where('slug = ?', self.slug)
      if existing_guide.present?
        update_column(:slug, "#{ApplicationController.helpers.to_slug(name, "for", payer, "in", state, (existing_guide.count + 1))}")
      else
        update_column(:slug, "#{ApplicationController.helpers.to_slug(name, "for", payer, "in", state)}")
      end
    end
  end
  
  def self.make_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each { |guide|  csv << guide.attributes.values_at(*column_names) }
    end
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Spreadsheet.open(file.path, extension: :xlsx)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def self.import(file, state)
    
  end
  
  def update_booleans(hash={})
    update_attributes(
      published_policies: hash["published_policies"].to_s.downcase == "yes" ? true : (hash["published_policies"].to_s.downcase == "no" ? false : nil),
      state_mandate_apply: hash["state_mandate_apply"].to_s.downcase == "yes" ? true : (hash["state_mandate_apply"].to_s.downcase == "no" ? false : nil),
      major_medical_benefit: hash["major_medical_benefit"].to_s.downcase == "yes" ? true : (hash["major_medical_benefit"].to_s.downcase == "no" ? false : nil),
      rx_benefit: hash["rx_benefit"].to_s.downcase == "yes" ? true : (hash["rx_benefit"].to_s.downcase == "no" ? false : nil),
      pa_required: hash["pa_required"].to_s.downcase == "yes" ? true : (hash["pa_required"].to_s.downcase == "no" ? false : nil),
      pa_form_required: hash["pa_form_required"].to_s.downcase == "yes" ? true : (hash["pa_form_required"].to_s.downcase == "no" ? false : nil),
      bo_modifier: hash["bo_modifier"].to_s.downcase == "yes" ? true : (hash["bo_modifier"].to_s.downcase == "no" ? false : nil),
      is_s9433: hash["is_s9433"].to_s.downcase == "yes" ? true : (hash["is_s9433"].to_s.downcase == "no" ? false : nil),
      formulary_exception_allowed: hash["formulary_exception_allowed"].to_s.downcase == "yes" ? true : (hash["formulary_exception_allowed"].to_s.downcase == "no" ? false : nil),
      formulary_form_required: hash["formulary_form_required"].to_s.downcase == "yes" ? true : (hash["formulary_form_required"].to_s.downcase == "no" ? false : nil),
      formulary_documentation_required: hash["formulary_documentation_required"].to_s.downcase == "yes" ? true : (hash["formulary_documentation_required"].to_s.downcase == "no" ? false : nil),
      reimbursement_fee_schedule: hash["reimbursement_fee_schedule"].to_s.downcase == "yes" ? true : (hash["reimbursement_fee_schedule"].to_s.downcase == "no" ? false : nil)
    )
  end  
  
end
