class AnswerBest < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :best_answer, index: true
  end
end
