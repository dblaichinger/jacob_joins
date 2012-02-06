class Recipe
  include Mongoid::Document
  field :name, :type => String
  field :portion, :type => Integer
  field :preparation, :type => String
  field :duration, :type => Integer
  field :unique_name, :type => String

  belongs_to :user
  has_and_belongs_to_many :ingredients

  attr_accessible :name, :portion, :preparation, :duration
end
