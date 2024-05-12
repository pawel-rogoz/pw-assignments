package league.tests;
import league.types.TeamPoints;
import org.junit.Test;
import static org.junit.Assert.*;

public class TeamPointsTest {
    @Test
    public void testPointsCreator(){
        TeamPoints teamPoints = new TeamPoints(10,10,10);
        assertEquals(40, teamPoints.points);
    }
}


