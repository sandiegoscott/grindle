class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :first_name, :last_name, :email, :crypted_password, :password_salt
      t.timestamps
      t.string :type, :default => 'User'
      t.boolean :inactive
      t.string :persistence_token
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.integer :builder_id
    end
  end
  
  def self.down
    drop_table :users
  end
end
