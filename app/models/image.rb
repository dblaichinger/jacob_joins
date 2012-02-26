class Image
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :recipe, :inverse_of => :images

  has_mongoid_attached_file :attachment,
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
    }
    #:path => ':rails_root/public/attachments/:attachment/:id/:style.:extension',
    #:url => '/attachments/:attachment/:id/:style.:extension',

end
