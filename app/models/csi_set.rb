class CsiSet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil, :autosave => true
  accepts_nested_attributes_for :country_specific_informations

  attr_accessible :country_specific_informations, :country_specific_informations_attributes

  def publish
    country_specific_informations.where(:state.ne => "published").and(:answer.ne => "").entries.all? { |csi| csi.publish }
  end

  def self.empty_set
    Question.all.map { |q| CountrySpecificInformation.new :question_reference => q, :question => q.text }
  end

  protected
  def method_missing(method, *args, &block)
    allowed_setters = [:city=, :country=, :latitude=, :longitude=, :user=]
    allowed_getters = [:user]

    if allowed_setters.include? method
      country_specific_informations.each do |csi|
        csi.send method, *args
        csi.save
      end
    elsif allowed_getters.include? method
      country_specific_informations.first.user
    else
      raise NoMethodError.new "undefined method `#{method}' for #{self}", method, args
    end
  end
end