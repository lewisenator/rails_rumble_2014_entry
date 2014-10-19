require 'omdb/network'
require 'omdb/movie'
require 'net/http'
require "uri"

class MoviesController < ApplicationController
  PER_PAGE = 12

  before_action :authenticate_user!

  def index
    @movies = UserMovieJoin.joins(:movie).
        where(user_id: current_user.id, in_library: true).
        order('movies.title asc').
        paginate(page: params[:page] || 1, per_page: PER_PAGE)
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
          url: movie_url(result.imdb_id)
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
      @movie.poster_image = URI(@movie.poster) unless @movie.poster == 'N/A'
      @movie.save!
    end
    @user_movie_join = UserMovieJoin.where(user_id: current_user.id, movie_id: @movie.id).first
    puts "imdb_id: #{imdb_id}"
  end

  def associate_user
    movie_id = params[:movie_id]
    existing = UserMovieJoin.where(user_id: current_user.id, movie_id: movie_id).first
    unless existing
      existing = UserMovieJoin.create!(user_id: current_user.id, movie_id: movie_id, in_library: true)
    end
    existing.in_library = true
    existing.save!
    render json: {success: true}
  end

  def disassociate_user
    movie_id = params[:movie_id]
    UserMovieJoin.where(user_id: current_user.id, movie_id: movie_id).all.each do |join|
      join.in_library = false
      join.save!
    end
    render json: {success: true}
  end

  def rate_user
    movie_id = params[:movie_id]
    your_rating = params[:your_rating]
    join = UserMovieJoin.where(user_id: current_user.id, movie_id: movie_id).first
    unless join
      join =  UserMovieJoin.create!(user_id: current_user.id, movie_id: movie_id, in_library: false)
    end
    join.your_rating = your_rating
    join.save!
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
