class AddPosterImageToMovie < ActiveRecord::Migration
  def self.up
    add_attachment :movies, :poster_image
  end

  def self.down
    remove_attachment :movies, :poster_image
  end
end
