class AddPaperclip < ActiveRecord::Migration
  
  def self.up
    add_attachment :photos, :image
  end

  def self.down
    remove_attachment :photos, :image
  end

end
