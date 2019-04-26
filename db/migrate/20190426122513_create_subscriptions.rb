class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :question_id
      t.integer :user_id

      t.index ["question_id"], name: "index_subscriptions_on_question_id"
      t.index ["user_id"], name: "index_subscriptions_on_user_id"

      t.timestamps
    end
  end
end
