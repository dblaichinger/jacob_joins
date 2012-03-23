class CSISet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil
  accepts_nested_attributes_for :country_specific_informations

  after_initialize :fill_with_empty_set

  attr_accessible :country_specific_informations, :country_specific_informations_attributes

  def self.empty_set
    csis = []
    Question.all.each do |q|
      csis << CountrySpecificInformation.new(:question_reference => q, :question => q.text)
    end
    csis
  end

  def update_attributes_by_question(params)
    if params["country_specific_informations_attributes"].present?
      params["country_specific_informations_attributes"].each do |csi_attributes|
        csi = self.country_specific_informations.find_or_initialize_by :question_reference_id => csi_attributes[1][:question_reference_id]
        csi.answer = csi_attributes[1]["answer"]
        csi.save
      end
      self.save
    end
  end

  protected
  def fill_with_empty_set
    self.country_specific_informations = CSISet.empty_set
  end
end