# frozen_string_literal: true

class JoinUserAnswer < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :answers, :user, index: true, foreign_key: true
  end
end
