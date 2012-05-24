class Step
  include Mongoid::Document
  include Mongoid::Paperclip

  field :description, :type => String
  field :number, :type => Integer

  embedded_in :recipe, :inverse_of => :steps
  
  has_mongoid_attached_file :image,
    :url => "/system/steps_images/:id/:style/:filename",
    :path => ":rails_root/public/system/steps_images/:id/:style/:filename",
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
    }
    
  validates_attachment_content_type :image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  state_machine :initial => :draft do
    event :publish do
      transition :draft => :published
    end

    event :unpublish do
      transition :published => :draft
    end

    state :published do
      validates_presence_of :description
    end
  end

  def to_jq_upload
    if self.image.present?
      {
        "name" => File.basename(self.image_file_name, '.*'),
        "size" => self.image_file_size,
        "thumbnail_url" => self.image.url(:small),
        "step_id" => self.id,
        "delete_url" => Rails.application.routes.url_helpers.recipes_delete_step_image_path(self.id)
      }
    end
  end

end
