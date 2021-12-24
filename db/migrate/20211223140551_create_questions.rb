class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false, index: true, unique: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
