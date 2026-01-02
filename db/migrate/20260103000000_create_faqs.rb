class CreateFaqs < ActiveRecord::Migration[8.1]
  def change
    create_table :faqs do |t|
      t.text :question, null: false
      t.text :answer, null: false
      t.integer :display_order, null: false, default: 1
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
