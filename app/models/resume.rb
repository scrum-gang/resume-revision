class Resume < ApplicationRecord
  #params.require(:resume).permit(:title, :revision, :user_name, :user_id)
  has_one_attached :data
  validates :title, presence: true
  validates :revision, presence: true
  validates :user_id, presence: true
  validates [:title, :user_id, :revision], uniqueness: true

  attr_accessor :resume_data

  after_create :parse_doc

  def parse_doc
    return if self.resume_data.nil?
    contents = self.resume_data.sub /data:((image|application)\/.{3,}),/, ''
    decoded_data = Base64.decode64(contents)
    filename = "#{self.title}_#{self.revision}_resume.pdf"
    File.open("#{Rails.root}/tmp/#{filename}", 'wb') do |f|
      f.write(decoded_data)
    end

    self.data.attach(io: File.open("#{Rails.root}/tmp/#{filename}"), filename: filename)
    FileUtils.rm("#{Rails.root}/tmp/#{filename}")
    self.download_resume_url = Rails.application.routes.url_helpers.rails_blob_path(self.data, only_path: true)
  end
end
