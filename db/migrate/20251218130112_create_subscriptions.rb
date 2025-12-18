class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :tier
      t.string :payment_method
      t.string :status

      t.timestamps
    end
  end
end
