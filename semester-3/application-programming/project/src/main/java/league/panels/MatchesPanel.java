package league.panels;

import league.conectivity.DataProvider;
import league.types.Match;
import javax.swing.*;
import java.awt.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class MatchesPanel extends LeagueViewingPanel{
    public MatchesPanel(){
        super(
                new String[]{"Drużyna A", "Drużyna B", "Lokacja", "Wynik", "Data"},
                "Tu będzie lista meczy jak użytkownik wybierze ligę.");
    }

    @Override
    protected IndexButton fillElementsPanel(DataProvider dataProvider, JPanel elementsPanel){
        Match[] matches  = dataProvider.getMatches();
        if(matches.length == 0){
            elementsPanel.add(new JLabel("W tej lidze nie ma żandych meczy"));
            return new IndexButton("", -1);
        }

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        for(Match match : matches){
            JPanel matchPanel = new JPanel(new GridLayout(1, 6));
            IndexButton button = new IndexButton("Zobacz mecz.", match.match_id);
            button.addActionListener(this);

            matchPanel.add(new JLabel(match.firstTeamName));
            matchPanel.add(new JLabel(match.secondTeamName));
            matchPanel.add(new JLabel(match.location));
            matchPanel.add(new JLabel(match.score));
            matchPanel.add(new JLabel(dateFormat.format(match.date)));
            matchPanel.add(button);

            elementsPanel.add(matchPanel);
        }

        return (IndexButton) ((JPanel) elementsPanel.getComponent(0)).getComponent(5);
    }

    @Override
    void launchNewWindow(int matchIndex){
        System.out.println("W Matches, zostałem kliknięty.");
        System.out.println("Indeks meczu to: " + matchIndex);

        //this frame contain only one panel, the one with match data
        Match match = dataProvider.getMatch(matchIndex);
        JFrame frame = new JFrame();
        if(match == null) showMessageAndExit(frame);
        frame.setTitle(match.firstTeamName + " vs " + match.secondTeamName);
        frame.setSize(300, 300);
        JPanel matchPanel = matchDataPanel(match);
        frame.add(matchPanel);
        frame.setVisible(true);
    }

    private JPanel matchDataPanel(Match match){
        //returns whole match data, based on given id
        DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd");
        JPanel matchPanel = new JPanel(new GridLayout(5, 1));
        matchPanel.add(new JLabel("Drużyna A: " + match.firstTeamName));
        matchPanel.add(new JLabel("Drużyna B: " + match.secondTeamName));
        matchPanel.add(new JLabel("Lokalizacja: " + match.location));
        matchPanel.add(new JLabel("Wynik: " + match.score));
        matchPanel.add(new JLabel("Data: " + dateFormat.format(match.date)));
        return matchPanel;
    }

    private void showMessageAndExit(JFrame frame){
        //to handle case when dataProvider cannot get any data
        JOptionPane.showMessageDialog(frame,"Connection with database lost.\n Check Your internet connection and try again.");
        System.exit(0);
    }
}
