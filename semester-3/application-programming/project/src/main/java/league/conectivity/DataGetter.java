package league.conectivity;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import league.types.*;

class DataGetter {
    /*
    All methods of this class are static, this class is used only to download data from database and return it.
     */

    static SimplePlayer[] getPlayers(int league_id) {
        LinkedList<SimplePlayer> playersList = getResultList("""
                        SELECT P.player_id AS playerId, P.team_id AS teamID,
                            P.name AS firstName, P.surname AS lastName, T.name AS teamName
                        FROM players P LEFT JOIN teams T
                                ON P.team_id = T.team_id
                            INNER JOIN team_plays_in_league TL
                                ON TL.team_id = T.team_id
                        WHERE TL.league_id = ?
                        ORDER BY P.surname, P.name
                            """,

                ((resultSet, resultList) -> {
                    resultList.add(new SimplePlayer(
                            resultSet.getInt("playerId"),
                            resultSet.getInt("teamID"),
                            resultSet.getString("firstName"),
                            resultSet.getString("lastName"),
                            resultSet.getString("teamName")
                    ));
                }),

                new int[]{league_id}
        );

        if (playersList == null) return null;
        return playersList.toArray(new SimplePlayer[playersList.size()]);
    }

    static FullPlayer getPlayer(int playerId) {
        LinkedList<FullPlayer> oneElementList = getResultList("""
                        SELECT P.player_id AS playerId, P.team_id AS teamID, P.birth_date as birthDate, P.height AS height, P.weight AS weight,
                               P.name AS firstName, P.surname AS lastName, T.name AS teamName, C.name AS origin
                        FROM players P LEFT JOIN teams T
                                ON P.team_id = T.team_id
                            LEFT JOIN countries C
                                ON P.birth_country_id = C.country_ID
                        WHERE P.player_id = ?
                                """,

                ((resultSet, resultList) -> {
                    Calendar now = Calendar.getInstance();
                    Calendar birthDate = Calendar.getInstance();
                    birthDate.setTime(resultSet.getDate("birthDate"));
                    int age = now.get(Calendar.YEAR) - birthDate.get(Calendar.YEAR);
                    if (birthDate.get(Calendar.DAY_OF_YEAR) > now.get(Calendar.DAY_OF_YEAR)) {
                        age--;
                    }

                    resultList.add(new FullPlayer(
                            resultSet.getInt("playerID"),
                            resultSet.getInt("teamID"),
                            age,
                            resultSet.getInt("weight"),
                            resultSet.getInt("height"),
                            resultSet.getString("firstName"),
                            resultSet.getString("lastName"),
                            resultSet.getString("teamName"),
                            resultSet.getString("origin")
                    ));
                }),

                new int[]{playerId}
        );

        if (oneElementList == null || oneElementList.size() != 1) {
            return null;
        }

        return oneElementList.getFirst();
    }

    static Match[] getMatches(int league_id) {
        LinkedList<Match> matchList = getResultList("""
                        SELECT  TM1.team_id AS firstTeamId, TM2.team_id AS secondTeamId, M.match_id as matchId,
                                T1.name AS firstTeamName, T2.name AS secondTeamName, 
                                TM1.goal_amount AS firstTeamGoals, TM2.goal_amount AS secondTeamGoals, S.name AS location,
                                M.match_date AS matchDate
                                
                        FROM team_plays_in_match TM1 INNER JOIN team_plays_in_match TM2
                                ON TM1.match_id = TM2.match_id AND TM1.team_id > TM2.team_id
                            INNER JOIN teams T1
                                ON TM1.team_id = T1.team_id
                            INNER JOIN teams T2
                                ON TM2.team_id = T2.team_id
                            INNER JOIN matches M
                                ON TM1.match_id = M.match_id
                            INNER JOIN stadiums S
                                ON S.stadium_id = M.stadium_id
                                
                        WHERE M.league_id = ?
                        ORDER BY M.match_date DESC
                                """,

                ((resultSet, resultList) -> {
                    resultList.add(new Match(
                            resultSet.getInt("firstTeamId"),
                            resultSet.getInt("secondTeamId"),
                            resultSet.getInt("matchId"),
                            resultSet.getString("firstTeamName"),
                            resultSet.getString("secondTeamName"),
                            resultSet.getString("location"),
                            "" + resultSet.getInt("firstTeamGoals") + ":" + resultSet.getInt("secondTeamGoals"),
                            new Date(resultSet.getDate("matchDate").getTime())

                    ));
                }),

                new int[]{league_id}
        );

        if (matchList == null) return null;
        return matchList.toArray(new Match[matchList.size()]);
    }

    static SimpleTeam[] getTeams(int league_id) {
        LinkedList<SimpleTeam> teamList = getResultList("""
                        SELECT T.team_id AS teamID, T.name AS teamName
                        FROM teams T INNER JOIN team_plays_in_league TL
                            ON T.team_id = TL.team_id
                        WHERE TL.league_id = ?
                        ORDER BY T.name
                        """,

                ((resultSet, resultList) -> {
                    resultList.add(new SimpleTeam(
                            resultSet.getInt("teamID"),
                            resultSet.getString("teamName")
                    ));
                }),

                new int[]{league_id}
        );

        if (teamList == null) return null;
        return teamList.toArray(new SimpleTeam[teamList.size()]);
    }

    static League[] getLeagues(){
        LinkedList<League>  leagueList = getResultList(
            """
            SELECT league_id AS leagueId, name AS leagueName
            FROM leagues
            """,

            (((resultSet, resultList) -> {
                resultList.add(new League(
                        resultSet.getInt("leagueId"),
                        resultSet.getString("leagueName")
                ));
            })),

            new int[]{}
        );
        if(leagueList == null) return null;
        return leagueList.toArray(new League[leagueList.size()]);
    }

    static String getTeamOrigin(int teamId){
        LinkedList<String> origin = getResultList("""
            SELECT C.name as origins
            FROM teams T INNER JOIN countries C
                ON T.country_id = C.country_id
            WHERE T.team_id = ?""",
            ((resultSet, resultList) -> {
                resultList.add(resultSet.getString("origins"));
            }),
            new int[]{teamId}
        );
        if(origin == null || origin.size() != 1) return null;
        return origin.getFirst();
    }

    static Country[] getCountries(){
        LinkedList<Country> countries = getResultList("""
            SELECT country_id as countryId, name as countryName
            FROM countries""",

                (((resultSet, resultList) -> {
                    resultList.add(new Country(
                            resultSet.getInt("countryId"),
                            resultSet.getString("countryName")
                    ));
                })),

                new int[]{}
        );

        if(countries == null) return null;
        return countries.toArray(new Country[countries.size()]);
    }

    static Stadium[] getStadiums(){
        LinkedList<Stadium> stadiums = getResultList("""
            SELECT stadium_id as stadiumId, name as stadiumName
            FROM stadiums""",

                (((resultSet, resultList) -> {
                    resultList.add(new Stadium(
                            resultSet.getInt("stadiumId"),
                            resultSet.getString("stadiumName")
                    ));
                })),

                new int[]{}
        );

        if(stadiums == null) return null;
        return stadiums.toArray(new Stadium[stadiums.size()]);
    }

    private static <ArrayType> LinkedList<ArrayType> getResultList(String qr, ListCreator<ArrayType>listCreator,
                                                          int parameters[]){
        Connection con = BaseConector.getConnection();
        if(con == null)
            return null;

        LinkedList<ArrayType> resultList = null;

        try{
            PreparedStatement stmt=con.prepareStatement(qr);
            for(int i = 0; i < parameters.length; i++) {
                stmt.setInt(i+1, parameters[i]);
            }

            ResultSet resultSet = stmt.executeQuery();
            resultList = new LinkedList<ArrayType>();

            while (resultSet.next()) {
                listCreator.addToList(resultSet, resultList);
            }
            resultSet.close();

        }catch(Exception e){
            resultList = null;
            System.out.println("The exception happened while trying get data from database. This is exception: ");
            e.printStackTrace();
        }finally {
            try { con.close(); } catch (Exception e) { /* Ignored */ }
        }

        return resultList;
    }

}



