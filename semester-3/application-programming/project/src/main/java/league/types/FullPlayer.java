package league.types;

public class FullPlayer extends  PlayerBase{
    public int age, height, weight;
    public String origin;

    public FullPlayer(int playerId, int teamId, int age,
                      int weight, int height,
                      String firstName, String lastName, String teamName, String origin) {
        super(playerId, teamId, firstName, lastName, teamName);
        this.age = age;
        this.origin = origin;
        this.height = height;
        this.weight = weight;
    }
}