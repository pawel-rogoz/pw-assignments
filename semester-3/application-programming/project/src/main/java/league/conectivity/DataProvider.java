package league.conectivity;

import league.types.*;
import java.util.LinkedList;

public class DataProvider {
    private final int league_id;
    private SimplePlayer[] players;
    private Match[] matches;
    private SimpleTeam[] teams;

    private static Stadium[] stadiums = null;
    private static Country[] countries = null;


    public static DataProvider getDataProvider(int league_id){
        /*
        This method downloads from database following things:
            1) array of all players in database who play in team, which is in specified league (see arg: league_id)
            2) array of all matches in database which belongs to specified league (see arg: league_id)
            3) array of all teams in database, which are in specified league (see arg: league_id)

         If there occurs any problem with downloading at least one of above arrays, then this method returns null.

         Otherwise, this method creates new object of DataProvider class. Previously downloaded data (those three arrays)
         are saved in newly created objects (in fields players, matches and teams).
         Finally, method returns this created DataProvider object.

         @return: DataProvider object or null;
         */

        DataProvider dataProvider = new DataProvider(league_id);
        if(dataProvider.refreshPlayers() && dataProvider.refreshMatches() && dataProvider.refreshTeams())
            return dataProvider;

        return null;
    }
    public static boolean prepareData(){
        return (refreshStadiums() && refreshCountries());
    }

    public static League[] getLeagues(){
        /*
        This method downloads from database array of all leagues and returns it.
        If an error ocurred  while trying to download data from database, then nul is returned.

         @return: DataProvider object or null;
         */
        return DataGetter.getLeagues();
    }

    /*Below three methods return arrays of players, matches and teams which are currently in memory of object, on which
     are called. If you want to download data from database instead of getting this, what is currently in app memory,
    then first call refreshPlayer method, and then call one af below three methods. For teams just like this:

    DataProvider myDataProvider = new DataProvider.getDataProvider(2); //suppose we want to operate on league of id 2
    <-- Doing staff with data, displaying on screen itd. -->
    myDataProvider.refreshTeams();
    PrettyPrint.printSimpleTeamsArray(myDataProvider.getTeams());
    */
    public SimplePlayer[] getPlayers() { return players; }
    public Match[] getMatches() { return matches; }
    public SimpleTeam[] getTeams() { return teams; }
    public static Stadium[] getStadiums(){return stadiums;}
    public static Country[] getCountries() { return countries; }
    public int getLeagueId(){ return league_id; }

    public FullPlayer getPlayer(int player_id){
        /* This method tries to download from database all information regarding player of given id.
        In case of success it returns FullPlayer object, which represents player of given id.

        If there is no player of specified id, then null is returned;
        If an error occurred when trying to get data from database (for example internet connection failure),
         then null is returned.

         Important: This method doesn't care what is currently in object's memory. It downloads all from database anyway.

         @return: FullPlayer or null
         */
        return DataGetter.getPlayer(player_id);
    }

    public FullTeam getTeam(int teamId){
        /*This method tries to find team of specified id in object's 'teams' array. If there is no team of specified id,
        then null is returned.
        If the team was found, then this method tries to get from database origin of the team (yes, just one String :D).
        If an error occurred when trying to get data from database (for example internet connection failure), then null
        is returned.

        Then method searches in object's 'matches' and 'players' arrays for all matches played in current league by the
        team and all players who play in current team. Then method creates new FullTeam object based on data which was
        gained in above mention steps.

        Important: the only thing this method downloads from database is team origin (yes, just one String)

        @return: FullTeam or null
         */

        SimpleTeam theTeam = null;
        for(SimpleTeam team: teams){
            if(team.teamID == teamId){
                theTeam = team;
                break;
            }
        }
        if(theTeam == null) return null;

        String origins = DataGetter.getTeamOrigin(teamId);
        if(origins == null) return null;

        LinkedList<SimplePlayer> teamPlayers = new LinkedList<SimplePlayer>();
        LinkedList<Match> teamMatches = new LinkedList<Match>();
        for(SimplePlayer player : players) {
            if(player.teamId == teamId){
                teamPlayers.add(player);
            }
        }
        for(Match match : matches){
            if(match.firstTeamId == teamId){
                teamMatches.add(match);
            } else if (match.secondTeamId == teamId) {
                String goals[] = match.score.split(":");
                teamMatches.add(new Match(
                        match.secondTeamId,
                        match.firstTeamId,
                        match.match_id,
                        match.secondTeamName,
                        match.firstTeamName,
                        match.location,
                        goals[1] + ":" + goals[0],
                        match.date
                ));
            }
        }

        return new FullTeam(teamId, theTeam.teamName, origins,
                teamMatches.toArray(new Match[teamMatches.size()]),
                teamPlayers.toArray(new SimplePlayer[teamPlayers.size()])
        );
    }

    public Match getMatch(int matchId){
        /*
        This method returns match of given id or null if match of given id was not found.
         */
        for (Match match : matches){
            if(match.match_id == matchId)
                return match;
        }
        return null;
    }

    public boolean refreshPlayers(){
    /*
    This method tries to download from database array of all players that plays in teams which are in current league.
    In case of success object's 'players' array is substituted by newly created players array and true is returned.

    If an error occurred when trying to get data from database (for example internet connection failure),
     then null is returned.
     */
        SimplePlayer[] refreshedPlayers = DataGetter.getPlayers(league_id);
        if(refreshedPlayers == null) return false;
        players = refreshedPlayers;
        return true;
    }
    public boolean refreshMatches(){
    /*
    This method tries to download from database array of all matches which belong to current league.
    In case of success object's 'matches' array is substituted by newly downloaded matches array and true is returned.

    If an error occurred when trying to get data from database (for example internet connection failure),
     then null is returned.
     */
        Match[] refreshedMatches = DataGetter.getMatches(league_id);
        if(refreshedMatches == null) return false;
        matches = refreshedMatches;
        return true;
    }
    public boolean refreshTeams(){
    /*
    This method tries to download from database array of all teams which play to current league.
    In case of success object's 'teams' array is substituted by newly downloaded teams array and true is returned.

    If an error occurred when trying to get data from database (for example internet connection failure),
     then null is returned.
     */
        SimpleTeam[] refreshedTeams = DataGetter.getTeams(league_id);
        if(refreshedTeams == null) return false;
        teams = refreshedTeams;
        return true;
    }

    public static boolean refreshStadiums(){
        Stadium[] refreshedStadiums = DataGetter.getStadiums();
        if(refreshedStadiums == null) return false;
        stadiums = refreshedStadiums;
        return true;
    }
    public static boolean refreshCountries(){
        Country[] refreshedCountries = DataGetter.getCountries();
        if(refreshedCountries == null) return false;
        countries = refreshedCountries;
        return true;
    }



    public TeamPoints count_team_points(int team_id){
        /*
        This method reaturns TeamPoints object of team of id team_id (arg).
        This method doesn't connect to internet.
        Using this method you don't need to check if result is null, result is never null;
         */
        int wonMatches = 0, lostMatches = 0, drawMatches = 0;
        for(Match match : matches){
            if(match.firstTeamId == team_id || match.secondTeamId == team_id){
                String[] goals = match.score.split(":");
                int my_team_goals = Integer.parseInt(goals[0]),
                        other_team_goals = Integer.parseInt(goals[1]);

                if(my_team_goals == other_team_goals){
                    drawMatches++;
                }else{
                    if(match.secondTeamId == team_id){
                        int temp = my_team_goals;
                        my_team_goals = other_team_goals;
                        other_team_goals = temp;
                    }

                    if(my_team_goals > other_team_goals){
                        wonMatches++;
                    }else{
                        lostMatches++;
                    }
                }
            }
        }
        return new TeamPoints(wonMatches, lostMatches, drawMatches);
    }



    private DataProvider(int league_id) {
        this.league_id = league_id;
        this.players = null;
        this.matches = null;
        this.teams = null;
    }
}
