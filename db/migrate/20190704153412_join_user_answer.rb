class JoinUserAnswer < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, index: true, foreign_key: true
  end
end
