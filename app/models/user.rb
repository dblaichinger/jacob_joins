class User
  include Mongoid::Document
  field :name, :type => String
  field :email, :type => String
  field :age, :type => Integer
  field :heard_from, :type => String
  field :gender, :type => String

  has_many :recipes

  validates_presence_of :name, :age, :gender
end
