class User
  include Mongoid::Document

  field :name, :type => String
  field :email, :type => String
  field :age, :type => Integer
  field :heard_from, :type => String
  field :gender, :type => String

  has_many :recipes
  has_many :country_specific_informations

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :name, :age, :gender
      validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "is invalid", :allow_blank => true
    end
  end
end
