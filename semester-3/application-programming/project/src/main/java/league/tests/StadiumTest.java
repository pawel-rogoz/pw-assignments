package league.tests;
import league.types.Stadium;
import org.junit.Test;
import static org.junit.Assert.*;

public class StadiumTest {
    @Test
    public void testStadiumToIndex(){
        Stadium stadium = new Stadium(10, "Suzuki Arena");
        assertEquals(10, stadium.toIndex());
    }

    @Test
    public void testStadiumToString(){
        Stadium stadium = new Stadium(10, "Suzuki Arena");
        assertEquals("Suzuki Arena", stadium.toString());
    }
}
