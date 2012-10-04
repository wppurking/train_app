# -*- encoding : utf-8 -*-
class AddRememberTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :remember_token, :string
    add_index :users, :remember_token, unique: true
  end

  def down
    remove_index :users, :remember_token
    remove_column :users, :remember_token
  end
end
