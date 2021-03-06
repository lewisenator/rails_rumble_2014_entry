# == Schema Information
#
# Table name: movies
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  year          :integer
#  imdb_id       :string(255)
#  rated         :string(255)
#  released      :date
#  runtime       :string(255)
#  genre         :text
#  director      :text
#  writer        :text
#  actors        :text
#  plot          :text
#  poster        :string(255)
#  imdb_rating   :string(255)
#  imdb_votes    :integer
#  metascore     :integer
#  language      :string(255)
#  country       :string(255)
#  awards        :text
#  tomato_rating :string(255)
#  production    :string(255)
#  website       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  movie_type    :string(255)
#

class Movie < ActiveRecord::Base
  has_many :user_movie_joins
  has_many :users, through: :user_movie_joins

  has_attached_file :poster_image, styles: {
      thumb: '100x100>',
      medium: '300x300>',
      large: '600x600>'
  }

  validates_attachment_content_type :poster_image, content_type: /\Aimage\/.*\Z/
end
