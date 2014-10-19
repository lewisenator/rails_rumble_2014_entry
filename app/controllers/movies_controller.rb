require 'omdb/network'
require 'omdb/movie'

class MoviesController < ApplicationController
  PER_PAGE = 16

  before_action :authenticate_user!

  def index
    @movies = current_user.movies.paginate(page: params[:page] || 1, per_page: PER_PAGE)
  end

  def search
    movies = []
    keywords = params[:keywords]
    results = Omdb::Api.new.search(keywords)
    results[:movies].select{|x| x.type == 'movie'}.each do |result|
      movie = {
          title: result.title,
          year: result.year,
          imdb_id: result.imdb_id,
          url: movie_path(result.imdb_id)
      }
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
          imdb_id: details.imdb_id
      )
      @movie.save!
    end
    @user_movie_join = UserMovieJoin.where(user_id: current_user.id, movie_id: @movie.id).first
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
