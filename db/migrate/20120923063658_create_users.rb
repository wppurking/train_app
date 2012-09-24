class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      # 用户姓名最多 30 个长度
      t.string :name, limit: 30
      t.string :email
      # 为 has_secure_password 提供支持
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
