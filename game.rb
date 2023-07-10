# require neccesary files
require_relative "get_input"
require_relative "pokedex/pokemons"
require_relative "player"
require_relative "battle"
require_relative "pokemon"

class Game
  include GetInput

  def start
    puts "
    #$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#
    #$#$#$#$#$#$#$                               $#$#$#$#$#$#$#
    #$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#
    #$#$#$#$#$#$#$                               $#$#$#$#$#$#$#
    #$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#

    Hello there! Welcome to the world of POKEMON! My name is OAK!
    People call me the POKEMON PROF!

    This world is inhabited by creatures called POKEMON! For some
    people, POKEMON are pets. Others use them forr fights. Myself...
    I study POKEMON as a profession.
    "

    user_name = get_input("First, What is your name?")

    puts "Right! So your name is #{user_name.upcase}!
    Your very own POKEMON legend is about to unfold! A world of
    dreams and adventures with POKEMON awaits! Let's go!

    Here, #{user_name.upcase}! There are 3 POKEMON here! Haha!
    When I was young, I was a serious POKEMON trainer.
    In my old age, I have only 3 left,  you can have one! Choose!"
    
    initials = Pokedex::POKEMONS.select { |key| ["Bulbasaur", "Charmander", "Squirtle"].include?(key) }
    pokemon = pokemon_input(initials)

    puts "You selected #{pokemon.upcase}. Great choice!"

    pokemon_name = pokemon_name_input(initials, pokemon)
    
    puts"#{user_name.upcase}, raise your young #{pokemon_name.upcase} by making it fight!
    When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
    player_1 = Player.new(user_name,pokemon,pokemon_name)
    begin
      action = ask_for_action_prompt
        case action
        when "Train"
          train(player_1)
        when "Leader"
          challenge_leader(player_1)
        when "Stats"
          show_stats(player_1)
        else 
          puts "Invalid option" if action != "Exit"
        end
    end while action != "Exit"
    puts "Goodbye"
  end
end


  def ask_for_action_prompt
  
    puts"-----------------------Menu-----------------------

  1. Stats        2. Train        3. Leader       4. Exit"
    puts "\n"

    print "> "
    action = gets.chomp.capitalize.to_s
  end


  def train(player_1)
    bot = Bot.new
    puts "\n#{player_1.user_name} challenges #{bot.name} for training"
    puts "#{bot.name} has a #{bot.pokemon.kind} level #{bot.pokemon.level}"
    action = ""
    until action == "Fight" || action == "Leave"
      puts "What do you want to do?"
      puts "1. Fight    2.Leave"
      print "> "
      action = gets.chomp.capitalize.to_s
      if action == "Fight"
        battle = Battle.new(player_1, bot)
        battle.start
      end
    end
  end

  def challenge_leader(player_1)
    brock = Brock.new
    puts "\n#{player_1.user_name} challenges the Gym Leader #{brock.name} for a fight!"
    puts "#{brock.name} has a #{brock.pokemon.kind} level #{brock.pokemon.level}"
    action = ""
    until action == "Fight" || action == "Leave"
      puts "What do you want to do?"
      puts "1. Fight    2.Leave"
      print "> "
      action = gets.chomp.capitalize.to_s
      if action == "Fight"
        battle = Battle.new(player_1, brock)
        battle.start
      end
      if brock.pokemon.hpb <= 0
        puts "Congratulation! You have won the game!"
        puts "You can continue training your Pokemon if you want"
      end
    end
  end

  def show_stats(player)
    puts "\n#{player.pokemon_name}:"
    puts "Kind: #{player.pokemon.kind}"
    puts "Level: #{player.pokemon.level}"
    puts "Stats:"
    player.pokemon.stats.each { |key, value| puts "#{key}: #{value}"}
    puts "Experience: #{player.pokemon.exp}"
    puts "Experience required for next level: #{player.pokemon.exp_required}"
  end

#   def goodbye
#     # Complete this
#   end

#   def menu
#     # Complete this
#   end
# end


