class SetDefaultInLibrary < ActiveRecord::Migration
  def change
    UserMovieJoin.all.each do |join|
      join.in_library = true
      join.save!
    end
  end
end
