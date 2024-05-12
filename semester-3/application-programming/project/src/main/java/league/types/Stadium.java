package league.types;

public class Stadium implements Indexer{
    public int stadiumId;
    public String stadiumName;

    public Stadium(int stadiumId, String stadiumName){
        this.stadiumId = stadiumId;
        this.stadiumName = stadiumName;
    }
    @Override
    public int toIndex() {return stadiumId; }
    @Override
    public String toString(){ return stadiumName; }
}
