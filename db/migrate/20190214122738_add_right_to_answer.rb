class AddRightToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :right_answer, :boolean, default: false
  end
end
