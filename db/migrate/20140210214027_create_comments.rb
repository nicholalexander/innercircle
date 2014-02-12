class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.timestamps
      t.belongs_to :user
      t.belongs_to :photo
    end
  end
end
