class AddInLibraryToUserMovieJoins < ActiveRecord::Migration
  def change
    add_column :user_movie_joins, :in_library, :boolean
  end
end
