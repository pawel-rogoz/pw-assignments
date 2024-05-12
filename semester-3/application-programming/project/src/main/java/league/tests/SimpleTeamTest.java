package league.tests;
import league.types.SimpleTeam;
import org.junit.Test;
import static org.junit.Assert.*;

public class SimpleTeamTest {
    @Test
    public void testSimpleTeamToIndex(){
        SimpleTeam simpleTeam = new SimpleTeam(10, "Korona Kielce");
        assertEquals(10, simpleTeam.toIndex());
    }

    @Test
    public void testSimpleTeamToString(){
        SimpleTeam simpleTeam = new SimpleTeam(10, "Korona Kielce");
        assertEquals("Korona Kielce", simpleTeam.toString());
    }
}
