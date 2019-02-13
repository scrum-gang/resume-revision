class AddResumeDownloadUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :resumes, :download_resume_url, :string
  end
end
