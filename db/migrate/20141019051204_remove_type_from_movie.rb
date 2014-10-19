class RemoveTypeFromMovie < ActiveRecord::Migration
  def change
  	remove_column :movies, :type, :string
  	add_column :movies, :movie_type, :string
  end
end
