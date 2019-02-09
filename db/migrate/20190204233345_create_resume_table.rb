class CreateResumeTable < ActiveRecord::Migration[5.2]
  def change
    create_table :resumes do |t|
      t.string :title
      t.string :revision
      t.string :user_name
      t.bigint :user_id
      t.string :download_resume_url
    end
  end
end
