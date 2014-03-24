require "./lib/player_stats"

desc "Find Baseball's Most Improved Batting Average"
task :find_most_improved_batting_average do |t, args|
  player_file = ENV['player_file']
  batting_file = ENV['batting_file']
  year = ENV['year']  
  puts "Loading the Player and Hitting data...".green
  @stats = PlayerStats.new(player_file,batting_file)
  winner = @stats.get_player(@stats.most_improved_batting_average(year)[0])
  print "The most improved player is "
  puts "#{winner['nameFirst']} #{winner['nameLast']}".cyan
  puts "With an improved batting average of #{winner[year.to_s]["batting_average_improved"]}"
  puts "from #{winner[(year.to_i - 1).to_s]["batting_average"]} in #{year.to_i - 1} to #{winner[year.to_s]["batting_average"]} in #{year}"
end

desc "Find Slugging Percentage of all Players on a Team"
task :find_slugging_percentage do |t, args|
  player_file = ENV['player_file']
  batting_file = ENV['batting_file']
  year = ENV['year']  
  team = ENV['team']  
  puts "Loading the Player and Hitting data for #{team} in #{year}...".green
  @stats = PlayerStats.new(player_file,batting_file)
  pr = @stats.players_on_team(team, year)
  pr.each do |k,v|
    print "Slugging % "
    print "#{v[year]['slugging_percentage']} ".yellow
    puts "for #{v['nameFirst']} #{v['nameLast']} in #{year}"
  end
end

desc "Find Triple Crown Winner"
task :find_slugging_percentage do |t, args|
  player_file = ENV['player_file']
  batting_file = ENV['batting_file']
  year = ENV['year']  
  puts "Loading the Player and Hitting data...".green
  @stats = PlayerStats.new(player_file,batting_file)
  # find all the players in each league (2 of them) for this year
    # find the highest batting_average
    # find the highest RBI
    # find the highest HomeRuns
    # if they are all the same person, that person wins
    # else "no winner"
    
end