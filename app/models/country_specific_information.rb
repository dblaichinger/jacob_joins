class CountrySpecificInformation
  include Mongoid::Document

  field :question, :type => String
  field :answer, :type => String
  field :city, :type => String
  field :country, :type => String
  field :latitude, :type => Float
  field :longitude, :type => Float

  belongs_to :question_reference, :class_name => "Question"
  belongs_to :user

  validates_presence_of :question_reference, :answer#, :city, :country, :latitude, :longitude

  before_save :get_question_text

  def self.new_set
    csis = []
    Question.all.each do |q|
      csis << CountrySpecificInformation.new(:question_reference => q, :question => q.text)
    end
    csis
  end

  def self.save_new_set(csis, eliminate_empty_answers = true)
    csis.select! { |csi| !csi[:answer].empty? } if eliminate_empty_answers
    worked = true
    new_set = []

    csis.each do |csi|
      new_csi = CountrySpecificInformation.new csi
      worked &= new_csi.save
      new_set << new_csi if worked
    end

    new_set if worked
  end

  protected
  def get_question_text
    self.question = self.question_reference.text
  end
end
