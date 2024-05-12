package league.panels;

import league.conectivity.DataProvider;
import javax.swing.*;


public abstract class LeaguePanel extends JPanel{
    /*
    An abstract class from witch derive all panels (panel with teams, panels with matches...).
    Method changeLeague is called when there is a need to show new things in the panel. Like when new league is chosen
    or when some data is redownload from database (refresh teams, refresh matches)
     */

    public abstract void changeLeague(DataProvider dataProvider);
}
