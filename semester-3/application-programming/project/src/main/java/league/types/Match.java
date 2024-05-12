package league.types;

import java.util.Date;

public class Match {

    public int firstTeamId, secondTeamId, match_id;
    public String firstTeamName, secondTeamName, location, score;
    public Date date;
    public Match(int firstTeamId, int secondTeamId, int match_id,
                 String firstTeamName, String secondTeamName, String location, String score,
                 Date date){
        this.firstTeamId = firstTeamId;
        this.secondTeamId = secondTeamId;
        this.match_id = match_id;
        this.firstTeamName = firstTeamName;
        this.secondTeamName = secondTeamName;
        this.score = score;
        this.date = date;
        this.location = location;
    }
}
