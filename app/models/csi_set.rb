class CSISet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil
  accepts_nested_attributes_for :country_specific_informations

  after_initialize :fill_with_empty_set

  def self.empty_set
    csis = []
    Question.all.each do |q|
      csis << CountrySpecificInformation.new(:question_reference => q, :question => q.text)
    end
    csis
  end

  protected
  def fill_with_empty_set
    self.country_specific_informations = CSISet.empty_set
  end
end