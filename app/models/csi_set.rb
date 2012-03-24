class CsiSet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil
  accepts_nested_attributes_for :country_specific_informations

  attr_accessible :country_specific_informations, :country_specific_informations_attributes

  def publish
    worked = true

    self.country_specific_informations.where(:state.ne => "published").entries.each do |csi|
      worked &&= csi.publish
    end
    
    worked ? self.destroy : false
  end

  def self.empty_set
    csis = []
    Question.all.each do |q|
      csis << CountrySpecificInformation.new(:question_reference => q, :question => q.text)
    end
    csis
  end

  protected
  def method_missing(method, *args, &block)
    allowed_methods = [:city=, :country=, :latitude=, :longitude=]
    if allowed_methods.include? method
      self.country_specific_informations.each do |csi|
        csi.send(method, *args)
      end
    else
      raise NoMethodError.new("undefined method `#{method}' for #{self}", method, args)
    end
  end
end