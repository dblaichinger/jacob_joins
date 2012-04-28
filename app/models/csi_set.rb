class CsiSet
  include Mongoid::Document

  has_and_belongs_to_many :country_specific_informations, :inverse_of => nil, :autosave => true
  accepts_nested_attributes_for :country_specific_informations

  def publish
    worked = true

    country_specific_informations.where(:state.ne => "published").and(:answer.ne => "").entries.each do |csi|
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