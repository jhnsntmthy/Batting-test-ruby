require "minitest/autorun"

require_relative "../lib/player_stats"

class TestPlayerStats < Minitest::Test
  def setup
    @stats = PlayerStats.new("Master-small.csv","Batting-07-12.csv")
  end
  
  def test_that_player_count_equals_18125
    assert_equal 18125, @stats.player_count
  end

  def test_that_batting_count_equals_7910
    assert_equal 7910, @stats.batting_count
  end

  def test_that_players_parses
    assert_equal "Hank", @stats.players.first["nameFirst"]
  end

  def test_that_battings_parses
    assert_equal "aardsda01", @stats.battings.first["playerID"]
  end

  def test_that_player_rankings_merges_together
    assert_equal "LAA", @stats.get_stats("abreubo01",2011,"teamID")
  end

  def test_that_player_batting_average_is_calculated
    assert_equal (sprintf "%.3f", (17.to_f/55.to_f)), @stats.get_stats("abercre01",2008,"batting_average")
  end

  def test_that_player_slugging_percentage_is_calculated
    assert_equal "0.509", @stats.get_stats("abercre01",2008,"slugging_percentage")
  end

  def test_that_only_players_with_stats_that_year_and_previous_year_are_selected
    assert @stats.players_with_years(2011,2012).all? {|k,v| v.has_key?("2011") && v.has_key?("2012") }
    assert @stats.players_with_years(2011,2009).all? {|k,v| v.has_key?("2009") && v.has_key?("2011") }
    assert @stats.players_with_years(2010,2012).all? {|k,v| v.has_key?("2010") && v.has_key?("2012") }
  end

  def test_player_most_improved_batting_average
    assert_equal "0.091", (sprintf "%.3f", @stats.most_improved_batting_average("2010")[1])
    assert_equal "hamiljo03", @stats.most_improved_batting_average("2010")[0]
    assert_equal "Josh", @stats.get_player(@stats.most_improved_batting_average("2010")[0])["nameFirst"]
  end

  def test_players_on_team_to_have_only_players_on_right_team_in_right_year
    pr = @stats.players_on_team("OAK", 2007)
    puts pr.keys
    assert pr.all? {|k,v| v.has_key?("2007") }
    assert pr.all? {|k,v| v["2007"]["teamID"] == "OAK" }
    assert_equal 44, pr.length
  end


  # def test_that_kitty_can_eat
  #   assert_equal "OHAI!", @stats.i_can_has_cheezburger?
  # end

  # def test_that_it_will_not_blend
  #   refute_match /^no/i, @stats.will_it_blend?
  # end

  # def test_that_will_be_skipped
  #   skip "test this later"
  # end
end