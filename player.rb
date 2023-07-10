# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokemon"

class Player
  attr_reader :user_name, :pokemon, :pokemon_name

  def initialize(user_name, pokemon, pokemon_name)
    @user_name = user_name
    @pokemon = Pokemon.new(pokemon)
    @pokemon_name = pokemon_name
  end

end


class Bot < Player
  attr_reader :pokemon, :name
  
  def initialize
    pokemons_arr = Pokedex::POKEMONS.select{ |k, v| {k => v} }
    pokemons_names = pokemons_arr.keys.sample
    @pokemon = Pokemon_bot.new(pokemons_names)
    @name = "Random Person"
  end
end

class Brock
  attr_reader :name, :pokemon

  def initialize
    @name = "Brock"
    @pokemon = Pokemon_brock.new
  end

end
