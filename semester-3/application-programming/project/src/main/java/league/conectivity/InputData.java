package league.conectivity;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class InputData {
    /*
    This class allows to input data from the graphic interface of our application to Oracle database.
    It has four methods:
    - inputPlayer - adds a new player to database
    - inputTeam - inserts to database a team that was described in "Dodaj drużynę" panel
    - inputMatch - this method adds information about match to database
    - inputLeague - adds a new league to database
     */
    public static boolean inputPlayer(int height, int weight, String name, String surname, String birthDate, String countryName, String teamName) {
        Connection con = BaseConector.getConnection();
        if (con == null)
            return false;
        try {
            // getting country_id by its name from database
            String getCountryId = "SELECT country_id FROM countries WHERE name like '"+ countryName + "'";
            PreparedStatement stmt = con.prepareStatement(getCountryId);
            ResultSet rs = stmt.executeQuery(getCountryId);
            int countryId = 0;
            if(rs.next())
                countryId = rs.getInt(1);
            
            // finding the biggest player_id and increasing the value by 1
            String getPlayerId = "SELECT max(player_id) FROM players";
            stmt = con.prepareStatement(getPlayerId);
            rs = stmt.executeQuery(getPlayerId);
            int playerId = 0;
            if(rs.next())
                playerId = rs.getInt(1);
            playerId += 1;

            // getting team_id by its name from database
            String get_team_id = "SELECT team_id FROM teams WHERE name = '" + teamName + "'";
            stmt = con.prepareStatement(get_team_id);
            rs = stmt.executeQuery(get_team_id);
            int teamId = 0;
            if(rs.next())
                teamId = rs.getInt(1);

            // main query
            String query = "INSERT INTO players (player_id, name, surname, birth_date, height, weight, birth_country_id, team_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt=con.prepareStatement(query);
            stmt.setInt(1, playerId);
            stmt.setString(2, name);
            stmt.setString(3, surname);
            stmt.setDate(4, java.sql.Date.valueOf(birthDate));
            stmt.setInt(5, height);
            stmt.setInt(6, weight);
            stmt.setInt(7, countryId);
            stmt.setInt(8, teamId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            // Prints what exception has been thrown
            System.out.println(e);
            return false;
        } finally {
            try { con.close(); } 
            catch (Exception e) { }
        }
        return true;
    }

    public static boolean inputTeam(int leagueId, String name, String acronym, String countryName) {
        Connection con = BaseConector.getConnection();
        if(con == null)
            return false;
        try {
            // finding the biggest team_id and increasing the value by 1
            String getTeamId = "SELECT max(team_id) FROM teams";
            PreparedStatement stmt = con.prepareStatement(getTeamId);
            ResultSet rs = stmt.executeQuery(getTeamId);
            int teamId = 0;
            if(rs.next())
                teamId = rs.getInt(1);
            teamId += 1;

            // getting country_id by its name 
            String get_country_id = "SELECT country_id FROM countries WHERE name like '"+ countryName + "'";
            stmt = con.prepareStatement(get_country_id);
            rs = stmt.executeQuery(get_country_id);
            int countryId = 0;
            if(rs.next())
                countryId = rs.getInt(1);

            // main queries
            String query = "INSERT INTO teams (name, team_id, acronym, country_id) VALUES (?, ?, ?, ?)";
            stmt = con.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setInt(2, teamId);
            stmt.setString(3, acronym);
            stmt.setInt(4, countryId);
            stmt.executeUpdate();

            query = "INSERT INTO team_plays_in_league (team_id, league_id) VALUES (?, ?)";
            stmt = con.prepareStatement(query);
            stmt.setInt(1, teamId);
            stmt.setInt(2, leagueId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
            return false;
        } finally {
            try { con.close(); }
            catch (Exception e) { }
        }
        return true;
    }
    public static boolean inputMatch(int goals1, int goals2, int leagueId, String date, String team1Name, String team2Name, String stadiumName) {
        // you need to pass the league_id from calling function
        Connection con = BaseConector.getConnection();
        if(con == null)
            return false;
        try {
            // getting ids of the two teams from database
            String getTeam1Id = "SELECT team_id FROM teams WHERE name = '" + team1Name + "'";
            PreparedStatement stmt = con.prepareStatement(getTeam1Id);
            ResultSet rs = stmt.executeQuery(getTeam1Id);
            int team1Id = 0;
            if(rs.next())
                team1Id = rs.getInt(1);

            String get_team2_id = "SELECT team_id FROM teams WHERE name = '" + team2Name + "'";
            stmt = con.prepareStatement(get_team2_id);
            rs = stmt.executeQuery(get_team2_id);
            int team2Id = 0;
            if(rs.next())
                team2Id = rs.getInt(1);

            // getting stadium_id by its name
            String get_stadium_id = "SELECT stadium_id FROM stadiums WHERE name = '" + stadiumName + "'";
            stmt = con.prepareStatement(get_stadium_id);
            rs = stmt.executeQuery(get_stadium_id);
            int stadiumId = 0;
            if(rs.next())
                stadiumId = rs.getInt(1);

            // finding the biggest match_id in the database and increasing by 1
            String getMatchId = "SELECT max(match_id) FROM matches";
            stmt = con.prepareStatement(getMatchId);
            rs = stmt.executeQuery(getMatchId);
            int matchId = 0;
            if(rs.next())
                matchId = rs.getInt(1);
            matchId += 1;

            //main queries
            String queryToMatches = "INSERT INTO matches (match_date, match_id, stadium_id, league_id) VALUES (?, ?, ?, ?)";
            stmt = con.prepareStatement(queryToMatches);
            stmt.setDate(1, java.sql.Date.valueOf(date));
            stmt.setInt(2, matchId);
            stmt.setInt(3, stadiumId);
            stmt.setInt(4, leagueId);
            String queryTo_team_plays_in_match1 = "INSERT INTO team_plays_in_match (team_id, match_id, goal_amount) VALUES (?, ?, ?)";
            PreparedStatement stmt1 = con.prepareStatement(queryTo_team_plays_in_match1);
            stmt1.setInt(1, team1Id);
            stmt1.setInt(2, matchId);
            stmt1.setInt(3, goals1);
            String queryTo_team_plays_in_match2 = "INSERT INTO team_plays_in_match (team_id, match_id, goal_amount) VALUES (?, ?, ?)";
            PreparedStatement stmt2 = con.prepareStatement(queryTo_team_plays_in_match2);
            stmt2.setInt(1, team2Id);
            stmt2.setInt(2, matchId);
            stmt2.setInt(3, goals2);
            stmt.executeUpdate();
            stmt1.executeUpdate();
            stmt2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
            return false;
        } finally {
            try { con.close(); }
            catch (Exception e) { }
        }
        return true;
    }
    public static boolean inputLeague(String name){
        Connection con = BaseConector.getConnection();
        if(con == null)
            return false;
        try {
            // getting max league_id and incrementing by 1
            String getLeagueId = "SELECT max(league_id) FROM leagues";
            PreparedStatement stmt = con.prepareStatement(getLeagueId);
            ResultSet rs = stmt.executeQuery(getLeagueId);
            int leagueId = 0;
            if(rs.next())
                leagueId = rs.getInt(1);
            leagueId += 1;

            // main query
            String queryToLeagues = "INSERT INTO leagues (league_id, name) VALUES (?, ?)";
            stmt = con.prepareStatement(queryToLeagues);
            stmt.setInt(1, leagueId);
            stmt.setString(2, name);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
            return false;
        } finally {
            try { con.close(); }
            catch (Exception e) { }
        }
        return true;
    }
}