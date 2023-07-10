# require_relative 'pokedex/moves'
require_relative "pokedex/pokemons"
require_relative 'player'
require_relative "pokedex/moves"


def calc_stats(level, ivs, effort_points, pokemon_chose, val)
  if val == 1
    ((2 * pokemon_chose + ivs + effort_points) * level / 100 + level + 10).floor
  else
    ((2 * pokemon_chose + ivs + effort_points) * level / 100 + level + 5).floor
  end
end


class Pokemon
  # include neccesary modules
attr_reader :kind, :type, :ivs, :effort_points, :exp, :exp_required, :pokemon_chose
attr_accessor :stats,:level, :hpb
  # (complete parameters)
  def initialize(pokemon)   
    @pokemon_chose = Pokedex::POKEMONS[pokemon]
    @level = 1
    @kind = pokemon_chose[:species]
    @type = pokemon_chose[:type]
    @ivs = { hp: rand(1..31), attack: rand(1..31), defense: rand(1..31), special_attack: rand(1..31), special_defense: rand(1..31), speed: rand(1..31) }
    @effort_points = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @stats = { hp: calc_stats(@level, @ivs[:hp], @effort_points[:hp], pokemon_chose[:base_stats][:hp], 1), 
      attack: calc_stats(@level, @ivs[:attack], @effort_points[:attack], pokemon_chose[:base_stats][:attack], 0), 
      defense: calc_stats(@level, @ivs[:defense], @effort_points[:defense], pokemon_chose[:base_stats][:defense], 0), 
      special_attack: calc_stats(@level, @ivs[:special_attack], @effort_points[:special_attack], pokemon_chose[:base_stats][:special_attack], 0), 
      special_defense: calc_stats(@level, @ivs[:special_defense], @effort_points[:special_defense], pokemon_chose[:base_stats][:special_defense], 0), 
      speed: calc_stats(@level, @ivs[:speed], @effort_points[:speed], pokemon_chose[:base_stats][:speed], 0) }
    @exp = 0
    growth_rate = pokemon_chose[:growth_rate]
    @exp_req = Pokedex::LEVEL_TABLES[growth_rate]
    @exp_required = @exp_req[@level]
    @hpb = @stats[:hp]
  end

  def prepare_for_battle
    @hpb = @stats[:hp]
  end

  def set_current_move
    current_move = ""
    move1 = pokemon_chose[:moves][0]
    move2 = pokemon_chose[:moves][1]
    until current_move == move1 || current_move == move2 
    puts "1.#{pokemon_chose[:moves][0]}     2.#{pokemon_chose[:moves][1]}"
    print "> "
    current_move = gets.chomp.downcase.to_s
    end
    current_move
  end

  def fainted?()
    !hpb.positive?
  end

  def attack(target, move)
    #Print attack message
  
    #Accuracy check
    if (rand(1..100)) <= move[:accuracy]
      # Calculate base damage
      
      if Pokedex::SPECIAL_MOVE_TYPE.include?(move[:type])
        damage = (((2 * level / 5.0 + 2).floor * stats[:special_attack] * move[:power] / target.stats[:special_defense]).floor / 50.0).floor + 2
      else
        damage = (((2 * level / 5.0 + 2).floor * stats[:attack] * move[:power] / target.stats[:defense]).floor / 50.0).floor + 2
      end
      
      if 7 >= (rand(1..100))
        puts "It was a CRITICAL hit!"
        damage *= 2
      end
      # Critical Hit check
    
      # Effectiveness check
      if target.pokemon_chose[:type].size == 1
        effectiveness = Pokedex::TYPE_MULTIPLIER.find { |key| key[:user] == move[:type] && key[:target] == target.pokemon_chose[:type][0] }
        effectiveness = effectiveness == nil ? 1 : effectiveness[:multiplier]
      else
        multp1 = Pokedex::TYPE_MULTIPLIER.find { |key| key[:user] == move[:type] && key[:target] == target.pokemon_chose[:type][0] }
        multp1 = multp1 == nil ? 1 : multp1[:multiplier]
        multp2 = Pokedex::TYPE_MULTIPLIER.find { |key| key[:user] == move[:type] && key[:target] == target.pokemon_chose[:type][1] }
        multp2 = multp2 == nil ? 1 : multp2[:multiplier]
        multp_result = multp1 * multp2
        case multp_result
          when 0 then effectiveness = 0
          when 0.25 then effectiveness = 0.5
          when 0.5 then effectiveness = 0.5
          when 1 then effectiveness = 1
          when 2 then effectiveness = 2
          when 4 then effectiveness = 2
        end
      end
        if effectiveness == 0.5
          puts "It's not very effective..."
        elsif effectiveness == 2
          puts "It's super effective!"
        elsif effectiveness == 0
          puts "It doesn't affect #{target.kind}!"
        end
      # Apply damage
      damage = (damage * effectiveness).floor
      target.hpb -= damage
  
      # Print damage message
      puts "And it hit #{target.kind} with #{damage} damage!"
    else
      puts "But it missed!"
    end
    puts "--------------------------------------------------"
    target.hpb
  end
  
  def increase_stats(target, p1)
    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"
    exp_gain = ((target.pokemon_chose[:base_exp] * target.level) / 7.0).floor 
    @exp += exp_gain
    @effort_points[target.pokemon_chose[:effort_points][:type]] += target.pokemon_chose[:effort_points][:amount]
    puts "#{p1.pokemon_name} gained #{exp_gain} experience points"
    if exp >= exp_required
      @level += 1
      @exp = 0
      puts "#{p1.pokemon_name} reached level #{@level}!"
      @exp_required = @exp_req[@level]
    end

    @stats = { hp: calc_stats(level, ivs[:hp], effort_points[:hp], pokemon_chose[:base_stats][:hp], 1), 
      attack: calc_stats(level, ivs[:attack], effort_points[:attack], pokemon_chose[:base_stats][:attack], 0), 
      defense: calc_stats(level, ivs[:defense], effort_points[:defense], pokemon_chose[:base_stats][:defense], 0), 
      special_attack: calc_stats(level, ivs[:special_attack], effort_points[:special_attack], pokemon_chose[:base_stats][:special_attack], 0), 
      special_defense: calc_stats(level, ivs[:special_defense], effort_points[:special_defense], pokemon_chose[:base_stats][:special_defense], 0), 
      speed: calc_stats(level, ivs[:speed], effort_points[:speed], pokemon_chose[:base_stats][:speed], 0) }

    # If the new experience point are enough to level up, do it and print
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
  end

  # private methods:
  # Create here auxiliary methods
end

class Pokemon_bot < Pokemon
  attr_reader :level, :kind, :type, :ivs, :effort_points, :stats, :pokemon_chose
  attr_accessor :hpb

  def initialize(pokemon_name)

    @pokemon_chose = Pokedex::POKEMONS[pokemon_name]
    @level = rand(1..7)
    @kind = pokemon_chose[:species]
    @type = pokemon_chose[:type]
    @ivs = { hp: rand(1..31), attack: rand(1..31), defense: rand(1..31), special_attack: rand(1..31), special_defense: rand(1..31), speed: rand(1..31) }
    @effort_points = { hp: rand(1..3), attack: rand(1..3), defense: rand(1..3), special_attack: rand(1..3), special_defense: rand(1..3), speed: rand(1..3) }
    @stats = { hp: calc_stats(@level, @ivs[:hp], @effort_points[:hp], pokemon_chose[:base_stats][:hp], 1), 
      attack: calc_stats(@level, @ivs[:attack], @effort_points[:attack], pokemon_chose[:base_stats][:attack], 0), 
      defense: calc_stats(@level, @ivs[:defense], @effort_points[:defense], pokemon_chose[:base_stats][:defense], 0), 
      special_attack: calc_stats(@level, @ivs[:special_attack], @effort_points[:special_attack], pokemon_chose[:base_stats][:special_attack], 0), 
      special_defense: calc_stats(@level, @ivs[:special_defense], @effort_points[:special_defense], pokemon_chose[:base_stats][:special_defense], 0), 
      speed: calc_stats(@level, @ivs[:speed], @effort_points[:speed], pokemon_chose[:base_stats][:speed], 0) }
    @hpb = @stats[:hp]
  end

  def set_current_move
    current_move = pokemon_chose[:moves][rand(0..1)]
  end

end

class Pokemon_brock < Pokemon
  attr_reader :level, :kind, :type, :ivs, :effort_points, :stats, :pokemon_chose
  attr_accessor :hpb
  
  def initialize
    
    @pokemon_chose = Pokedex::POKEMONS["Onix"]
    @level = 10
    @kind = pokemon_chose[:species]
    @type = pokemon_chose[:type]
    @ivs = { hp: rand(1..31), attack: rand(1..31), defense: rand(1..31), special_attack: rand(1..31), special_defense: rand(1..31), speed: rand(1..31) }
    @effort_points = { hp: rand(3..7), attack: rand(3..7), defense: rand(3..7), special_attack: rand(3..7), special_defense: rand(3..7), speed: rand(3..7) }
    @stats = { hp: calc_stats(@level, @ivs[:hp], @effort_points[:hp], pokemon_chose[:base_stats][:hp], 1), 
      attack: calc_stats(@level, @ivs[:attack], @effort_points[:attack], pokemon_chose[:base_stats][:attack], 0), 
      defense: calc_stats(@level, @ivs[:defense], @effort_points[:defense], pokemon_chose[:base_stats][:defense], 0), 
      special_attack: calc_stats(@level, @ivs[:special_attack], @effort_points[:special_attack], pokemon_chose[:base_stats][:special_attack], 0), 
      special_defense: calc_stats(@level, @ivs[:special_defense], @effort_points[:special_defense], pokemon_chose[:base_stats][:special_defense], 0), 
      speed: calc_stats(@level, @ivs[:speed], @effort_points[:speed], pokemon_chose[:base_stats][:speed], 0) }
    @hpb = @stats[:hp]
  end

  def set_current_move
    current_move = pokemon_chose[:moves][rand(0..1)]
  end
end
