class CreatePartnerApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :partner_applications, if_not_exists: true do |t|
      t.string :organization_name
      t.string :website
      t.string :country
      t.text :description
      t.string :organization_type
      t.string :contact_name
      t.string :contact_email
      t.string :key_sectors
      t.string :collaboration_areas
      t.string :other_organization_type
      t.string :other_key_sectors
      t.string :other_collaboration_areas
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
