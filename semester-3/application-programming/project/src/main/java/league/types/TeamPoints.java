package league.types;

public class TeamPoints {
    public int wonMatches, lostMatches, drawMatches, points;

    public TeamPoints(int wonMatches, int lostMatches, int drawMatches){
        this.wonMatches = wonMatches;
        this.lostMatches = lostMatches;
        this.drawMatches = drawMatches;
        points = 3 * wonMatches + drawMatches;
    }
}
