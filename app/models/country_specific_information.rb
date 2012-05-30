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

  attr_accessible :question, :answer, :city, :country, :latitude, :longitude, :user, :question_reference
  attr_accessible :question, :answer, :city, :country, :latitude, :longitude, :user, :question_reference, :state, :as => :admin

  before_save :get_question_text

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :question_reference, :answer, :city, :country, :latitude, :longitude
    end
  end

  protected
  def get_question_text
    question = question_reference.text if question_reference.present?
  end
end
