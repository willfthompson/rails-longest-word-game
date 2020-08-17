require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def score
    user_word = params['user-word']
    letters = params[:letters]
    dictionary = URI.open("https://wagon-dictionary.herokuapp.com/#{user_word}")
    result = JSON.parse(dictionary.string)
    if result['found']
      if contains_all?(letters, user_word)
        @response = "Congratulations! #{user_word.upcase} is a winning word!"
        @score = (user_word.length * user_word.length)
        @total_score += @score
      else
        @response = "Boo! '#{user_word}' is not in these letters (#{letters.upcase})"
        @score = 0
      end
    else
      @response = "Boo! '#{user_word}' is not in the dictionary"
      @score = 0
    end
  end

  private

  def contains_all?(grid, attempt)
    attempt = attempt.split("")
    grid = grid.split(" ")
    attempt.map!(&:upcase)
    grid.map!(&:upcase)
    result = attempt.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
    result
  end
end
