module ApplicationHelper
  
  def to_slug(*strings)
    array = []
     strings.each do |string|
       array << string.to_s.downcase unless string.nil?
     end
    array.join(" ").downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').gsub("- ", "").gsub("--", "-")
  end
  
end
