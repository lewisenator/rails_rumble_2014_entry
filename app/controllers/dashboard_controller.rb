class DashboardController < ApplicationController
	before_action :authenticate_user!

	def index
    @sections = [{
      image_name: 'clapper_perspective.png',
      name: 'Movies',
      url: movies_path
    }, {
      image_name: 'book_coming_soon.png',
      name: 'Books',
      url: '#'
    }, {
      image_name: 'game_coming_soon.png',
      name: 'Video Games',
      url: '#'
    }].map{|x| OpenStruct.new(x)}
	end
end
