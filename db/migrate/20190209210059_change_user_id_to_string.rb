class ChangeUserIdToString < ActiveRecord::Migration[5.2]
  def change
    change_column :resumes, :user_id, :string
  end
end
