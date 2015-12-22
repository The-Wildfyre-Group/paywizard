class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Required to establish account.
      t.string :password_digest, :null => false, :default => ""
      t.string :email, :null => false, :default => ""
      
      ## Name information.
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      
      ## Recoverable - Forgot Password.
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      
      ## For remember - keep me logged in.
      t.string :authentication_token
      
      ## For friendly ID.
      t.string :slug
      
      ## user_type
      t.boolean :admin
       
      t.timestamps
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :authentication_token, :unique => true
    add_index :users, :slug, :unique => true
  end
end

