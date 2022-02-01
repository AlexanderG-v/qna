class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :votable, polymorphic: true
      t.references :user, null: false

      t.timestamps
    end
  end
end
