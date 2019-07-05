class JoinUserQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :user_id, :bigint
  end
end
