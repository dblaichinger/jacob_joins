class User
  include Mongoid::Document
  field :name, :type => String
  field :email, :type => String
  field :age, :type => Integer
  field :heard_from, :type => String
  field :female, :type => Boolean

  has_many :recipes
end
