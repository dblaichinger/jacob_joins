class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :email, :type => String
  field :age, :type => Integer
  field :heard_from, :type => String
  field :gender, :type => String

  has_many :recipes

  validates_presence_of :name, :age, :gender
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "is invalid", :allow_blank => true


  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end
