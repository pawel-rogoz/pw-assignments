package league;
import league.conectivity.DataProvider;
import league.panels.*;
import league.types.League;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.HashMap;
import javax.swing.*;

import static javax.swing.WindowConstants.EXIT_ON_CLOSE;


public class SwingApp{
    JMenu menu, refreshMenu;
    JFrame frame;
    ArrayList<JMenuItem> items;
    HashMap<String, Integer> leaguesData;
    JMenuBar mb;
    LeaguePanel[] leaguePanels;
    DataProvider dataProvider;
    JTabbedPane tabbedPane;
    public SwingApp() {
        //creating leagues to run dataProvider

        frame = new JFrame();
        League[] leagues = DataProvider.getLeagues();
        if(leagues == null) showMessageAndExit(frame);

        if(!DataProvider.prepareData()) showMessageAndExit(frame);


        //initializing variables

        mb = new JMenuBar();
        menu = new JMenu("Wybierz Ligę");
        refreshMenu = new JMenu("Zaktualizuj dane");
        items = new ArrayList<>();
        leaguesData = new HashMap<String, Integer>();

        // creating JTabbedPane and its Pane's
        tabbedPane = new JTabbedPane();
        leaguePanels = new LeaguePanel[]{new MatchesPanel(), new TeamsPanel(), new PlayersPanel(), new TeamPointsPanel(), new AddingPanel()};//LINE MODIFIED BY JCh

        tabbedPane.add("mecze", leaguePanels[0]);
        tabbedPane.add("zespoły", leaguePanels[1]);
        tabbedPane.add("zawodnicy", leaguePanels[2]);
        tabbedPane.add("tabela", leaguePanels[3]); //line modified
        tabbedPane.add("Dodaj", leaguePanels[4]);

        JMenuItem refreshMatches = new JMenuItem("Odśwież mecze");
        JMenuItem refreshTeams = new JMenuItem("Odśwież zespoły");
        JMenuItem refreshPlayers = new JMenuItem("Odśwież zawodników");
        ActionListener refreshListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if(dataProvider == null){
                    showFailureMessage(frame);
                    return;
                }

                JMenuItem item = (JMenuItem) e.getSource();

                if (item == refreshMatches){
                    if (dataProvider.refreshMatches()){
                        leaguePanels[0].changeLeague(dataProvider);
                        leaguePanels[3].changeLeague(dataProvider);
                        showSuccessMessage(frame);
                    } else {
                        showConnectionFailureMessage(frame);
                    }
                } else if (item == refreshTeams) {
                    if (dataProvider.refreshTeams()) {
                        leaguePanels[1].changeLeague(dataProvider);
                        leaguePanels[3].changeLeague(dataProvider);
                        leaguePanels[4].changeLeague(dataProvider);
                        showSuccessMessage(frame);
                    } else {
                        showConnectionFailureMessage(frame);
                    }
                } else if (item == refreshPlayers) {
                    if (dataProvider.refreshPlayers()) {
                        leaguePanels[2].changeLeague(dataProvider);
                        showSuccessMessage(frame);
                    } else {
                        showConnectionFailureMessage(frame);
                    }
                }
            }
        };


        refreshMatches.addActionListener(refreshListener);
        refreshTeams.addActionListener(refreshListener);
        refreshPlayers.addActionListener(refreshListener);
        refreshMenu.add(refreshMatches);
        refreshMenu.add(refreshTeams);
        refreshMenu.add(refreshPlayers);


        //creating a MenuBar with its items
        for (League league : leagues) {
            JMenuItem menuItem = new JMenuItem(league.leagueName);
            items.add(menuItem);
            leaguesData.put(league.leagueName, league.leagueId);
        }

        for (JMenuItem item : items) {
            menu.add(item);
            item.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    JMenuItem item = (JMenuItem) e.getSource();
                    String name = item.getText();
                    Integer leagueID = leaguesData.get(name);
                    dataProvider = DataProvider.getDataProvider(leagueID);
                    if(dataProvider == null) showMessageAndExit(frame);
                    menu.setText(name + " (zmień ligę)");

                    for (LeaguePanel leaguePanel: leaguePanels){
                        leaguePanel.changeLeague(dataProvider);
                    }
                }
            });
        }

        mb.add(menu);
        mb.add(refreshMenu);
        frame.add(tabbedPane);
        frame.setTitle("Ligi piłkarskie");
        frame.setJMenuBar(mb);
        frame.setLayout(new GridLayout());
        frame.setSize(600, 600);
        frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
    public static void main(String args[]) {
        new SwingApp();
    }
    private void showMessageAndExit(JFrame frame){
        JOptionPane.showMessageDialog(frame,"Connection with database lost.\n Check Your internet connection and try again.");
        System.exit(0);
    }

    private void showFailureMessage(JFrame frame){
        JOptionPane.showMessageDialog(frame, "You have to choose league first");
    }

    private void showConnectionFailureMessage(JFrame frame){
        JOptionPane.showMessageDialog(frame, "Connection with database lost.\n Check Your internet connection and try again.");
    }

    private void showSuccessMessage(JFrame frame){
        JOptionPane.showMessageDialog(frame, "Succesfully updated");
    }
}

