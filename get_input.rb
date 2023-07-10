require_relative "pokedex/pokemons"

module GetInput
  def get_input(prompt)
    input = ""
    while input.empty?
    puts prompt
    print "> "
    input = gets.chomp
    end
    input
  end

  def pokemon_input(initials)
    pokemon = ""
    puts "\n"+"    "+"1. Bulbasaur    2. Charmander   3. Squirtle"
    until initials.keys.include?(pokemon)
    print "> "
    pokemon = gets.chomp.capitalize
    end
    pokemon
  end
    
  def pokemon_name_input(initials,pokemon)
    puts "Give your pokemon a name?"
    print "> "
    pokemon_name = gets.chomp
    if pokemon_name.empty?
      pokemon_name = initials[pokemon][:species]
    end
    pokemon_name
  end
end