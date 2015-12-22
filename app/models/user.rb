class User < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :use_for_slug, use: [:slugged, :finders]
  before_update :update_slug
  has_secure_password
  
  validates_presence_of :password, :on => :create
  validates :first_name, :presence => true, length: {minimum: 2, maximum: 20}
  validates :last_name, :presence => true, length: {minimum: 2, maximum: 20}
  validates :email, :uniqueness => true, allow_blank: true
  

  before_save { self.email = email.downcase }

  before_create { generate_token(:authentication_token) }

  after_update :password_changed?, :on => :update
  before_save :encrypt_password
  
  attr_accessor :current_password

  def password_changed?
    #if (provider.nil? || provider.try(:empty?))
      if password_digest_changed?
        # self.update_attributes(old_password: "example")
         #Emails.password_changed(self).deliver
      end
      #end
  end

  def full_name
    [first_name, middle_name,last_name].join(" ")
  end

  def use_for_slug
    existing_user = User.where('first_name = ?', self.first_name).where('last_name = ?', self.last_name)
    if existing_user.present?
      "#{first_name} #{last_name} #{existing_user.count}"
    else
      "#{first_name} #{last_name}"
    end
  end
  
  def update_slug
    if (first_name_changed? || last_name_changed?)
      existing_user = minus_self.where('first_name = ?', self.first_name).where('last_name = ?', self.last_name)
      if existing_user.present?
        update_column(:slug, "#{ApplicationController.helpers.to_slug(first_name, last_name, (existing_user.count + 1))}")
      else
        update_column(:slug, "#{ApplicationController.helpers.to_slug(first_name, last_name)}")
      end
    end
  end

  def encrypt_password
    unless self.password.nil?
      self.password_digest = BCrypt::Password.create(self.password)
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    SendEmail.password_reset(self).deliver
  end
  
  
end
