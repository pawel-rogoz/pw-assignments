package league.tests;
import league.types.Country;
import org.junit.Test;
import static org.junit.Assert.*;

public class CountryTest {
    @Test
    public void testCountryToIndex(){
        Country country = new Country(10, "Polska");
        assertEquals(10, country.toIndex());
    }

    @Test
    public void testCountryToString(){
        Country country = new Country(10, "Polska");
        assertEquals("Polska", country.toString());
    }
}
