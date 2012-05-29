class Question
  include Mongoid::Document

  field :text, :type => String

  has_many :country_specific_informations

  attr_accessible :text, :country_specific_informations

  validates_presence_of :text

  before_save :update_country_specific_informations

  protected
  def update_country_specific_informations
    self.country_specific_informations.each do |csi|
      csi.question = self.text
      csi.save
    end
  end
end
