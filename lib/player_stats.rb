require 'csv'
require 'bigdecimal'
require_relative 'ext/string'

class PlayerStats

  attr_accessor :players, :battings, :player_rankings
  
  def initialize(player_csv, batting_csv)
    @players ||= []
    @player_rankings ||= Hash.new
    CSV.foreach(player_csv, headers: true) do |row|
      player = row.to_hash
      @players << player
      @player_rankings[player["playerID"]] = player
    end
    @battings ||= []
    CSV.foreach(batting_csv, headers: true) do |row|
      batting = row.to_hash
      @battings << batting
      @player_rankings[batting["playerID"]][batting["yearID"]] = batting
      @player_rankings[batting["playerID"]][batting["yearID"]]["batting_average"] = calculate_batting_average(batting)
      @player_rankings[batting["playerID"]][batting["yearID"]]["slugging_percentage"] = calculate_slugging_percentage(batting)
    end
  end

  def player_count
    players.size
  end

  def batting_count
    battings.size
  end

  def get_player(id)
    player_rankings[id]
  end

  def get_stats(id, year, stat_name=nil)
    entry = get_player(id)[year.to_s]
    stat_name ? entry[stat_name] : entry
  end

  def most_improved_batting_average(year, minimum_at_bats=200)
    improvements = []
    year = year.to_i #normalize

    player_selection = players_with_years(year, year-1)
    player_selection.reject!{|k,v| v[year.to_s]["H"].nil? || v[year.to_s]["AB"].nil? || v[year.to_s]["AB"].to_i < minimum_at_bats || v[(year - 1).to_s]["H"].nil? || v[(year - 1).to_s]["AB"].nil? || v[(year - 1).to_s]["AB"].to_i < minimum_at_bats} 
    player_selection.each do |k,v| 
      v[year.to_s]["batting_average_improved"] = v[year.to_s]["batting_average"].to_f - v[(year-1).to_s]["batting_average"].to_f 
      improvements << [k,v[year.to_s]["batting_average_improved"],v[year.to_s]["batting_average"],v[(year-1).to_s]["batting_average"]]
    end
    improvements.sort {|x,y| y[1] <=> x[1] }.first
  end

  def players_on_team(team,year)
    year = year.to_s
    player_rankings.select {|k,v| v.has_key?(year) && v[year]["teamID"] == team }
  end

  def players_with_years(*years)
    pr = player_rankings
    years.each do |year|
      pr = pr.select{|k,v| v.has_key?(year.to_s) }
    end
    pr
  end

  protected

  def calculate_batting_average(batting)
    hits = batting["H"].to_i || 0
    at_bats = batting["AB"].to_i || 0
    total = (hits.to_f / at_bats.to_f)
    total = 0 if total.nan?
    sprintf "%.3f", total
  end

  def calculate_slugging_percentage(batting)
    hits = batting["H"].to_i || 0
    doubles = batting["2B"].to_i || 0
    triples = batting["3B"].to_i || 0
    homers = batting["HR"].to_i || 0
    at_bats = batting["AB"].to_i || 0
    total = (((hits - doubles - triples - homers) + (2 * doubles) + (3 * triples) + (4 * homers)).to_f / at_bats.to_f)
    total = 0 if total.nan?
    sprintf "%.3f", total
  end

  
end