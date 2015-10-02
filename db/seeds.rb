# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



  states = ["Maryland", "Georgia", "Louisiana", "California", "Texas"]
  payer_names = ["Aetna", "BlueCross", "Wellpoint", "United Health", "Kaiser"]
  products = ["Tylenol", "Albuterol", "Adderall", "Acetaminophen", "Ibuprofen"]
  
  
  products.each do |product|
    states.each do |state|
      guide = Guide.create(
      state: state,
      name: product,
      payer_name: payer_names.sample,
      covered: [true, false].sample,
      coverage_notes: "Example coverage notes for #{product} in #{state}.",
      current_link: "http://www.#{product}-#{state}.com",
      old_link: "N/A",
      link_notes: "site was undergoing construction but it works now.",
      prior_authorization: [true, false].sample,
      authorization_notes: "something",
      phone_number: "#{(100..999).to_a.sample} #{(100..999).to_a.sample} #{(1000..9999).to_a.sample}",
      fax_number: "#{(100..999).to_a.sample} #{(100..999).to_a.sample} #{(1000..9999).to_a.sample}")
    end
  end

    