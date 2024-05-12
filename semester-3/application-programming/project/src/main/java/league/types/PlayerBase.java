package league.types;

abstract public class PlayerBase {
    public PlayerBase(int playerId, int teamId, String firstName, String lastName, String teamName){
        this.playerId = playerId;
        this.teamId = teamId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.teamName = teamName;
    };
    public int playerId, teamId;
    public String firstName, lastName, teamName;
}
