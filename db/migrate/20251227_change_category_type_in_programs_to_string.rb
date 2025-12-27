class ChangeCategoryTypeInProgramsToString < ActiveRecord::Migration[7.0]
  def up
    return if column_already_string?
    change_column :programs, :category, :string, using: 'category::text'
  end

  def down
    # Only revert if the column is string
    return unless column_already_string?
    change_column :programs, :category, :integer, using: 'category::integer'
  end

  private

  def column_already_string?
    col = connection.columns(:programs).find { |c| c.name == 'category' }
    col && col.type == :string
  end
end
