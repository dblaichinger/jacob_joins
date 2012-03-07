class Step
  include Mongoid::Document
  include Mongoid::Paperclip

  field :description, :type => String

  embedded_in :recipe
  
  has_mongoid_attached_file :image,
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
    }

  validates_presence_of :description

end
