class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :firstname, :type => String
  field :lastname, :type => String
  field :email, :type => String
  field :age, :type => Integer
  field :heard_from, :type => String
  field :gender, :type => String

  has_one :recipe
  has_many :country_specific_informations

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    state :published do
      validates_presence_of :firstname, :age, :gender
      validates :age, :numericality => { :only_integer => true }
      validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "is invalid", :allow_blank => true
    end
  end

  def formatted_user_info
    "#{firstname} #{shorten_lastname} #{"(#{age})" if age.present?}"
  end

  private

  def shorten_lastname
    return "" unless lastname.present?
    "#{lastname[0]}."
  end
end
