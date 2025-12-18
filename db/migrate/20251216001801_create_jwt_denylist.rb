class CreateJwtDenylist < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:jwt_denylists)

    create_table :jwt_denylists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end

    add_index :jwt_denylists, :jti
  end
end
