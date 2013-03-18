class LogError
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Storage

  ERROR_TYPES = %w[info warning fatal debug]

  field :title, :type => String
  field :data, :type => String
  field :type, :type => String, :default => "info"
  field :log_key, :type => String
  index :log_key

  validate :check_log_key, :on => :create

  def to_api_hash(options = {})
    log_error_hash = {
        :id => _id.to_s,
        :title => title,
        :data => data,
    }

    log_error_hash[:type] = self.class.to_s

    log_error_hash
  end

  protected

  def check_log_key
     log = Log.where(key: self.log_key)
     errors.add :content, 'Invalid log key' if log.empty?
  end
end
