class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Storage

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[owner user moderator admin]


  ## Database authenticatable
  field :email,              :type => String, :default => ""
  index :email
  field :encrypted_password, :type => String, :default => ""

  field :name,                :type => String, :limit => 100
  field :role,                :type => String, :default => "user"
  field :log_ids,             :type => Array, :default => []


  validates_presence_of :email
  validates_inclusion_of :role, :in => ROLES

  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :email, :in => 6..100

  with_options :if => :password_required? do |v|
    v.validates_presence_of     :password
    v.validates_confirmation_of :password
    v.validates_length_of       :password, :in => 6..20, :allow_blank => true
  end

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
end
