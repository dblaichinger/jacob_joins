class Recipe
  include Mongoid::Document
  include Mongoid::Slug

  field :name, :type => String
  field :portion, :type => Integer
  field :preparation, :type => String
  field :duration, :type => Integer
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float

  belongs_to :user
  has_and_belongs_to_many :ingredients

  attr_accessible :name, :portion, :preparation, :duration, :city, :country, :latitude, :longitude
  validates_presence_of :name, :portion, :preparation, :duration, :city, :country, :latitude, :longitude

  slug :name
end
