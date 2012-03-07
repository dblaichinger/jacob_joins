class CountrySpecificInformation
  include Mongoid::Document

  field :question, :type => String
  field :answer, :type => String

  belongs_to :question
  

end
