require_relative "pokedex/moves"
require_relative "pokemon"

class Battle
  attr_reader :p1, :bot
  # (complete parameters)
  def initialize(p1, bot)
    @p1 = p1
    @bot = bot
  end

  def start
    # Prepare the Battle (print messages and prepare pokemons)
    p1.pokemon.prepare_for_battle

    puts "\n#{bot.name} sent out #{bot.pokemon.kind.upcase}!"
    puts "#{p1.user_name} sent out #{p1.pokemon_name.upcase}!"
    puts "-------------------Battle Start!-------------------"
    until p1.pokemon.fainted? || bot.pokemon.fainted?
      puts "#{p1.user_name}'s #{p1.pokemon_name} - Level #{p1.pokemon.level}"
      puts "HP: #{p1.pokemon.hpb}"
      puts "#{bot.name}'s #{bot.pokemon.kind} - Level #{bot.pokemon.level}"
      puts "HP: #{bot.pokemon.hpb}\n"
      puts "#{p1.user_name}, select your move:\n"
      current_p1_move = p1.pokemon.set_current_move
      current_bot_move = bot.pokemon.set_current_move

      arr_move = []
      arr_move.push(Pokedex::MOVES.values.select { |k| k[:name] == current_p1_move })
      arr_move.push(Pokedex::MOVES.values.select { |k| k[:name] == current_bot_move })

      if arr_move[0].first[:priority] == arr_move[1].first[:priority]
        if p1.pokemon.stats[:speed] == bot.pokemon.stats[:speed]
          arr_move_name = [current_p1_move, current_bot_move]
          arr_move_name.shuffle!
          first = arr_move_name.pop
          second = arr_move_name.pop
        elsif p1.pokemon.stats[:speed] > bot.pokemon.stats[:speed]
          first = current_p1_move
          second = current_bot_move
        else
          first = current_bot_move
          second = current_p1_move
        end
      elsif arr_move[0].first[:priority] > arr_move[1].first[:priority]
        first = current_p1_move
        second = current_bot_move
      else
        first = current_bot_move
        second = current_p1_move
      end
       
      if first == current_p1_move
        attack_first = arr_move[0]
        attack_second = arr_move[1]
        puts "--------------------------------------------------"
        puts "\n#{p1.pokemon_name} used #{current_p1_move.upcase}!"
        bot.pokemon.hpb = p1.pokemon.attack(bot.pokemon, arr_move[0].first)
        if bot.pokemon.fainted?
          puts "#{bot.pokemon.kind} FAINTED!"
          puts "--------------------------------------------------"
          puts "#{p1.pokemon_name} WINS!"
          p1.pokemon.increase_stats(bot.pokemon, p1)
          puts "-------------------Battle Ended!-------------------"
        else
          puts "#{bot.pokemon.kind} used #{current_bot_move.upcase}!"
          p1.pokemon.hpb = bot.pokemon.attack(p1.pokemon, arr_move[1].first)
          if p1.pokemon.fainted?
            puts "#{p1.pokemon_name} FAINTED!"
            puts "--------------------------------------------------"
            puts "#{bot.pokemon.kind} WINS!"
            puts "-------------------Battle Ended!-------------------"
          end
        end
      else
        attack_first = arr_move[1]
        attack_second = arr_move[0]
        puts "--------------------------------------------------"
        puts "#{bot.pokemon.kind} used #{current_bot_move.upcase}!"
        p1.pokemon.hpb = bot.pokemon.attack(p1.pokemon, arr_move[1].first)
        if p1.pokemon.fainted?
          puts "#{p1.pokemon_name} FAINTED!"
          puts "--------------------------------------------------"
          puts "#{bot.pokemon.kind} WINS!"
          puts "-------------------Battle Ended!-------------------"
        else
          puts "#{p1.pokemon_name} used #{current_p1_move.upcase}!"
          bot.pokemon.hpb = p1.pokemon.attack(bot.pokemon, arr_move[0].first)
          if bot.pokemon.fainted?
            puts "#{bot.pokemon.kind} FAINTED!"
            puts "--------------------------------------------------"
            puts "#{p1.pokemon_name} WINS!"
            p1.pokemon.increase_stats(bot.pokemon, p1)
            puts "-------------------Battle Ended!-------------------"
          end
        end
      end
    end
  end
end
