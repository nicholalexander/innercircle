class AddPhotosTable < ActiveRecord::Migration
  
  def change
    create_table :photos do |t|
      t.string :title
      t.string :description
      t.timestamps
      t.belongs_to :user
    end
  end

end
