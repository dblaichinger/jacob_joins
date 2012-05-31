class CsiSet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil, :autosave => true
  accepts_nested_attributes_for :country_specific_informations

  attr_accessible :country_specific_informations, :country_specific_informations_attributes

  def publish
    country_specific_informations.where(:state.ne => "published").and(:answer => "").entries.all? { |csi| csi.destroy }
    country_specific_informations.where(:state.ne => "published").entries.all? { |csi| csi.publish }
  end

  def self.empty_set
    Question.all.map { |q| CountrySpecificInformation.new :question_reference => q, :question => q.text }
  end
end