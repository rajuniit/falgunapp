class Log
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :key, :type => String

  field :api_code, :type => String

  referenced_in   :user, :class_name => "User"

  validates_presence_of :user, :name
  validates_uniqueness_of :key

  validates_length_of :name, :in => 3..40

  validate :generate_api_code, :on => :create


  protected

  def generate_api_code
    self.api_code =  SecureRandom.hex(16)
  end


end
