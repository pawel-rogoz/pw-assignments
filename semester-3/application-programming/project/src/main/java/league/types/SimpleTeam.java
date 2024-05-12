package league.types;

public class SimpleTeam extends TeamBase implements Indexer{
    public SimpleTeam(int teamId, String teamName){
        super(teamId, teamName);
    }

    @Override
    public int toIndex() {return teamID; }
    @Override
    public String toString(){ return teamName; }
}
