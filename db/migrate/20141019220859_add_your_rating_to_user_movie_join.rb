class AddYourRatingToUserMovieJoin < ActiveRecord::Migration
  def change
    add_column :user_movie_joins, :your_rating, :integer
  end
end
