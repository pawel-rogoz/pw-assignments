package league.panels;

import league.conectivity.DataProvider;
import league.types.*;
import javax.swing.*;
import java.awt.*;

public class TeamsPanel extends LeagueViewingPanel{
    public TeamsPanel(){
        super(
            new String[]{"Nazwa Drużyny"},
            "Tu będzie lista drużyn jak użytkownik wybierze ligę.");
    }

    @Override
    protected IndexButton fillElementsPanel(DataProvider dataProvider, JPanel elementsPanel){
        SimpleTeam[] teams  = dataProvider.getTeams();
        if(teams.length == 0){
            elementsPanel.add(new JLabel("W tej lidze nie ma żandych drużyn."));
            return new IndexButton("", -1);
        }

        for(SimpleTeam team : teams){
            JPanel teamsPanel = new JPanel(new GridLayout(1, 2));
            IndexButton button = new IndexButton("Zobacz drużynę.", team.teamID);
            button.addActionListener(this);

            teamsPanel.add(new JLabel(team.teamName));
            teamsPanel.add(button);

            elementsPanel.add(teamsPanel);
        }
        return (IndexButton) ((JPanel) elementsPanel.getComponent(0)).getComponent(1);
    }

    @Override
    void launchNewWindow(int teamIndex){
        System.out.println("W Teams, zostałem kliknięty");
        System.out.println("Indeks druzyny to: " + teamIndex);

        JFrame frame = new JFrame();
        //getting team object as it will be needed to create panels
        FullTeam team = dataProvider.getTeam(teamIndex);
        if (team == null) showMessageAndExit(frame);

        frame.setTitle(team.teamName);
        //creating two JPanels, tabbedPane's components
        JPanel teamDataPanel = teamDataPanel(team);
        JPanel teamPlayerPanel = teamPlayerPanel(team, frame);
        JTabbedPane tabbedPane = new JTabbedPane();

        tabbedPane.add("Informacje", teamDataPanel);
        tabbedPane.add("Zawodnicy", teamPlayerPanel);
        frame.add(tabbedPane);

        frame.setSize(300, 300);

        frame.setVisible(true);
    }

    private JPanel teamDataPanel(FullTeam team){
        JPanel teamData = new JPanel(new GridLayout(2, 1));
        teamData.add(new JLabel("Nazwa: " + team.teamName));
        teamData.add(new JLabel("Kraj: " + team.origins));
        return teamData;
    }

    private JPanel teamPlayerPanel(FullTeam team, JFrame frame){
        JPanel teamPlayerPanel = new JPanel(new BorderLayout()); //panel which consists all other panels
        int teamId = team.teamID;
        JPanel elementsPanel = new JPanel();
        BoxLayout elementsPanelLayout = new BoxLayout(elementsPanel, BoxLayout.PAGE_AXIS);
        elementsPanel.setLayout(elementsPanelLayout);

        SimplePlayer[] players = dataProvider.getPlayers();
        if(players == null) showMessageAndExit(frame);

        //adding players
        for (SimplePlayer player : players){
            if (player.teamId == teamId){
                JPanel data = new JPanel(new GridLayout(1, 2));
                data.add(new JLabel(player.firstName));
                data.add(new JLabel(player.lastName));
                elementsPanel.add(data);
            }
        }

        JPanel header = new JPanel(new GridLayout(1, 2));
        header.add(new JLabel("Imię"));
        header.add(new JLabel("Nazwisko"));


        JScrollPane scrollPane = new JScrollPane(elementsPanel);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        teamPlayerPanel.add(header, BorderLayout.PAGE_START);
        teamPlayerPanel.add(scrollPane, BorderLayout.CENTER);

        return teamPlayerPanel;
    }

    private void showMessageAndExit(JFrame frame){
        //to handle case when dataProvider cannot get any data
        JOptionPane.showMessageDialog(frame,"Connection with database lost.\n Check Your internet connection and try again.");
        System.exit(0);
    }
}
