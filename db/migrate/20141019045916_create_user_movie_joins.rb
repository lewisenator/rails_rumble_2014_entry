class CreateUserMovieJoins < ActiveRecord::Migration
  def change
    create_table :user_movie_joins do |t|
      t.references :user, index: true
      t.references :movie, index: true

      t.timestamps
    end
  end
end
