class Ingredient
  include Mongoid::Document

  field :name, :type => String

  has_and_belongs_to_many :recipes

  validates_presence_of :name

  def self.names_with(query)
    names = []
    Ingredient.only(:name).where(:name => /#{query}/i).entries.each do |i|
      names << i.name
    end
    names
  end

  def self.search(ingredient)
    Ingredient.where("name" => ingredient)
  end
end
