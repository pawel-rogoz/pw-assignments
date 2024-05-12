package league.tests;

import league.types.*;

public class PrettyPrint {
    public static String populateToN(String word, int n){
        if(word == null){
            word = "NULL";
        }
        return word + " ".repeat(Math.max(0, n-word.length()));
    }
    public static String populateToN(int number, int n){
        return populateToN(Integer.toString(number), n);
    }

    public static void printSimplePlayerArray(SimplePlayer[] players){
        if(players == null){
            System.out.println("players are null!");
        }

        final int n = 30;
        System.out.println( populateToN("playerId", n) + populateToN("teamId", n) +
                populateToN("firstName", n) + populateToN("lastName", n) +
                populateToN("teamName", n) );
        for(SimplePlayer player : players){

            System.out.println( populateToN(player.playerId, n) + populateToN(player.teamId, n) +
                    populateToN(player.firstName, n) + populateToN(player.lastName, n) +
                    populateToN(player.teamName, n) );
        }
    }

    public static void printSimpleMatchArray(Match[] matches){
        if(matches == null){
            System.out.println("matches are null!");
            return;
        }

        final int n = 25;
        System.out.println( populateToN("firstTeamId", n) + populateToN("secondTeamId", n) +
                populateToN("firstTeamName", n) + populateToN("SecondTeamName", n) +
                populateToN("location", n) + populateToN("score", n) + populateToN("date", n));
        for(Match match : matches){
            System.out.println( populateToN(match.firstTeamId, n) + populateToN(match.secondTeamId, n) +
                    populateToN(match.firstTeamName, n) + populateToN(match.secondTeamName, n) +
                    populateToN(match.location, n) + populateToN(match.score, n) +
                    populateToN(match.date.toString() ,n) );
        }
    }

    public static void printSimpleTeamsArray(SimpleTeam[] teams){
        if(teams == null){
            System.out.println("matches are null!");
            return;
        }

        final int n = 30;
        System.out.println( populateToN("teamId", n) + populateToN("teamName", n));
        for(SimpleTeam team : teams){
            System.out.println( populateToN(team.teamID, n) + populateToN(team.teamName, n) );
        }
    }

    public static void printFullPlayer(FullPlayer player){
        if(player == null){
            System.out.println("player is null!");
            return;
        }
        System.out.println("playerId: " + player.playerId + " teamID: " + player.teamId + " age: " + player.age +
                " height: " + player.height + " weight: " + player.weight + " firstName: " + player.firstName +
                " lastName: " + player.lastName + " teamName: " + player.teamName + " origin: " + player.origin);
    }

    public static void printFullTeam(FullTeam team){
        if(team == null){
            System.out.println("The team is null!");
            return;
        }
        System.out.println("teamId: " + team.teamID + ", teamName: " + team.teamName + ", origin" + team.origins);
        System.out.println("Those are teams matches: ");
        printSimpleMatchArray(team.matches);
    }

    public static void printLeagueArray(League[] leagues){
        if(leagues == null){
            System.out.println("Leagues are null!");
            return;
        }
        final int n = 25;
        System.out.println( populateToN("leagueId", n) + populateToN("leagueName", n));
        for(League league : leagues){
            System.out.println( populateToN(league.leagueId, n) + populateToN(league.leagueName, n));
        }
    }
}
