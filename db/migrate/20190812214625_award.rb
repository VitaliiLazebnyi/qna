# frozen_string_literal: true

class Award < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :title
      t.string :url
      t.belongs_to :question
      t.belongs_to :user
      t.timestamps
    end
  end
end
