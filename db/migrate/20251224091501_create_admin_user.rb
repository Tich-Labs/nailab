class CreateAdminUser < ActiveRecord::Migration[8.1]
  def up
    unless AdminUser.exists?(email: 'admin@nailab.com')
      AdminUser.create!(email: 'admin@nailab.com', password: 'pa$$word@123', password_confirmation: 'pa$$word@123')
    end
  end

  def down
    AdminUser.find_by(email: 'admin@nailab.com')&.destroy
  end
end
