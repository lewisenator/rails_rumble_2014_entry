require 'omdb/network'
require 'omdb/movie'

class MoviesController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def search
    movies = []
    keywords = params[:keywords]
    results = Omdb::Api.new.search(keywords)
    results[:movies].select{|x| x.type == 'movie'}.each do |result|
      # details = fetch_details(result.imdb_id)[:movie]
      # puts "details: #{details}"
      movie = {
          title: result.title,
          year: result.year,
          imdb_id: result.imdb_id,
          url: movie_path(result.imdb_id)
      }

      # [:rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :poster, :metascore, :language, :country, :awards].each do |key|
      #   movie[key] = eval("details.#{key.to_s}").split(',').map{|x| x.strip} rescue ''
      #   if movie[key].length == 1
      #     movie[key] = movie[key][0]
      #   end
      # end
      movies.push(movie)
    end
    movies = movies.sort_by!{|x| x[:year].to_i}.reverse
    render json: {results: movies, keywords: keywords}
  end

  def show
    imdb_id = params[:id]
    @movie = Movie.find_by_imdb_id(imdb_id)
    unless @movie
      details = fetch_details(imdb_id)[:movie]
      @movie = Movie.new(
          title: details.title,
          imdb_id: details.imdb_id,
          year: details.year,
          movie_type: details.type,
          rated: details.rated,
          released: details.released,
          runtime: details.runtime,
          genre: details.genre,
          director: details.director,
          writer: details.writer,
          actors: details.actors,
          plot: details.plot,
          poster: details.poster,
          imdb_rating: details.imdb_rating,
          imdb_votes: details.imdb_votes,
          metascore: details.metascore,
          language: details.language,
          country: details.country,
          awards: details.awards,
          tomato_rating: details.tomato_rating,
          production: details.production,
          website: details.website
      )
      @movie.save!
    end
    puts "imdb_id: #{imdb_id}"
  end

  private

  def fetch_details(imdb_id)
    res = network.call({i: imdb_id, tomatoes: true, plot: "full"})
    if res[:data]["Response"] == "False"
      response = {:status => 404}
    else
      response = {
        status: res[:code],
        movie: parse_movie(res[:data])
      }
    end
  end

  def parse_movies(json_string)
    data = json_string["Search"]
    movies = Array.new
    data.each do |movie|
      movies.push(parse_movie(movie))
    end
    return movies
  end

  def parse_movie(data)
    Omdb::Movie.new(data)
  end

  def network
    @network ||= Omdb::Network.new
  end
end
