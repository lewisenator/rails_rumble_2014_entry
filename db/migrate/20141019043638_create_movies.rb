class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.string :imdb_id
      t.string :type
      t.string :rated
      t.date :released
      t.string :runtime
      t.text :genre
      t.text :director
      t.text :writer
      t.text :actors
      t.text :plot
      t.string :poster
      t.string :imdb_rating
      t.integer :imdb_votes
      t.integer :metascore
      t.string :language
      t.string :country
      t.text :awards
      t.string :tomato_rating
      t.string :production
      t.string :website

      t.timestamps
    end
  end
end
