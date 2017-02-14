require 'game.rb'
class PagesController < ApplicationController

  def game
    @grid = generate_grid
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @grid = params[:grid].split("")
    @word = params[:word]
    check_grid(@word, @grid)
    check_english(@word)
    translation(@word)
    @result = run_game(@word, @grid, Time.parse(params[:start_time]), @end_time)
  end
end
