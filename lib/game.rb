require 'open-uri'
require 'json'

def generate_grid
  # TODO: generate random grid of lette2rs
  return (0...9).map { ('A'..'Z').to_a[rand(26)] }
end

def check_grid(attempt, grid)
  # check if word is made from grid letters
  attempt_array = attempt.upcase.scan(/\w/)
  return attempt_array.all? { |letter| grid.count(letter) >= attempt_array.count(letter) }
end

def check_english(attempt)
  # check if English word
  english_words = File.read('/usr/share/dict/words').upcase.split("\n")
  english_words.any? { |word| attempt.upcase == word.upcase }
end

def translation(attempt)
  # translate using API
  api = "15ac92d0-cbfb-43a6-ad44-c41643352718"
  att = attempt.downcase
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api}&input=#{att}"
  translation = open(url).read
  translated_word = JSON.parse(translation)
  return translated_word["outputs"][0]["output"]
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  # calculate time taken to answer
  result = {}
  result[:time] = (end_time - start_time)
  if check_grid(attempt, grid) && check_english(attempt)
    result[:translation] = translation(attempt)
    result[:message] = "well done"
    result[:score] = ((attempt.size.to_f / result[:time].to_f) * 10.0).to_f
  elsif check_grid(attempt, grid)
    result[:message] = "not an english word"
    result[:score] = 0
    result[:translation] = nil
  else
    result[:message] = "not in the grid"
    result[:score] = 0
    result[:translation] = translation(attempt)
  end
  result
end
