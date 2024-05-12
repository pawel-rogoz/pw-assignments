package league.types;

public class FullTeam extends TeamBase{

    public Match[] matches;
    private SimplePlayer[] players;
    public String origins; //kraj z Której Pochodza, dla Jagelonii będzie to "Polska"


    public FullTeam(int teamId, String teamName, String origins, Match[] matches, SimplePlayer[] players){
        super(teamId, teamName);
        this.origins = origins;
        this.matches = matches;
        this.players = players;
    }

}
