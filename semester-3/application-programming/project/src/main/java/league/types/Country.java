package league.types;

public class Country implements Indexer{
    public int countryId;
    public String countryName;

    public Country(int countryId, String countryName){
        this.countryId = countryId;
        this.countryName = countryName;
    }

    @Override
    public int toIndex() {return countryId; }
    @Override
    public String toString(){ return countryName; }
}
