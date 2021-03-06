# Generated by Errorkit.
#
# Create an errors table for managing errors.
class CreateErrors < ActiveRecord::Migration[5.0]
  def self.up
    create_table :errors do |t|
      t.string :environment
      t.string :server
      t.string :version
      t.string :exception
      t.text   :message
      t.text   :backtrace
      t.string :controller
      t.string :action
      t.string :remote_ip
      t.text :request_env
      t.text :session
      t.text :params
      t.string :worker
      t.string :queue
      t.text :payload
      t.text :url
      t.integer :user_id
      t.integer :subject_id
      t.string :subject_type
      t.datetime :resolved_at

      t.timestamps index: true, null: false
    end

    add_index :errors, :exception
    add_index :errors, :resolved_at
  end

  def self.down
    drop_table :errors
  end
end
