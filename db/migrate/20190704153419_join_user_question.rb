# frozen_string_literal: true

class JoinUserQuestion < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :questions, :user, index: true, foreign_key: true
  end
end
