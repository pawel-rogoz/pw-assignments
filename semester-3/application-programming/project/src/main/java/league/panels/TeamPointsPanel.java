package league.panels;

import league.conectivity.DataProvider;
import league.types.*;
import org.javatuples.Pair;

import javax.swing.*;
import java.awt.*;
import java.util.Arrays;
import java.util.Comparator;

public class TeamPointsPanel extends LeagueViewingPanel{

    public TeamPointsPanel() {
        super(new String[]{"Nazwa drużyny", "Liczba punktów", "Rozegrane mecze", "Wygrane", "Zremisowane", "Przegrane"},
                "Tu będzie tabela ligi, jak użytkownik wybierze ligę");
    }

    @Override
    protected IndexButton fillElementsPanel(DataProvider dataProvider, JPanel elementsPanel){
        SimpleTeam[] teams = dataProvider.getTeams();
        if(teams.length == 0){
            elementsPanel.add(new JLabel("W tej lidze nie ma żadnych drużyn."));
            return new IndexButton("", -1);
        }

        Pair<SimpleTeam, TeamPoints>[] points = new Pair[teams.length];
        for(int i = 0; i<teams.length; i++){
            points[i] = new Pair<SimpleTeam, TeamPoints>(teams[i], dataProvider.count_team_points(teams[i].teamID));
        }
        Arrays.sort(points, new Comparator<Pair<SimpleTeam, TeamPoints>>() {
            @Override
            public int compare(Pair<SimpleTeam, TeamPoints> p1, Pair<SimpleTeam, TeamPoints> p2) {
                return Integer.compare(p1.getValue1().points, p2.getValue1().points);
            }
        });

        for(int i = points.length-1; i>=0; i--){
            SimpleTeam team = points[i].getValue0();
            TeamPoints teamPoints = points[i].getValue1();

            JPanel teamPointsPanel = new JPanel(new GridLayout(1, 7));
            IndexButton button = new IndexButton("Zobacz wyniki", team.teamID);
            button.addActionListener(this);

            teamPointsPanel.add(new JLabel(team.teamName));
            teamPointsPanel.add(new JLabel(String.valueOf(teamPoints.points)));
            teamPointsPanel.add(new JLabel(String.valueOf(teamPoints.wonMatches + teamPoints.drawMatches + teamPoints.lostMatches)));
            teamPointsPanel.add(new JLabel(String.valueOf(teamPoints.wonMatches)));
            teamPointsPanel.add(new JLabel(String.valueOf(teamPoints.drawMatches)));
            teamPointsPanel.add(new JLabel(String.valueOf(teamPoints.lostMatches)));
            teamPointsPanel.add(button);

            elementsPanel.add(teamPointsPanel);
        }
        return (IndexButton) ((JPanel) elementsPanel.getComponent(0)).getComponent(6);
    }

    @Override
    void launchNewWindow(int teamIndex) {
        JFrame frame = new JFrame();
        FullTeam fullTeam = dataProvider.getTeam(teamIndex);
        frame.setTitle(fullTeam.teamName + " - mecze");
        Match[] matches = fullTeam.matches;
        JTabbedPane tabbedPane = matchesTabbedPane(matches, teamIndex);

        frame.add(tabbedPane);

        frame.setSize(300,300);
        frame.setVisible(true);
    }

    private JTabbedPane matchesTabbedPane(Match[] matches, int teamIndex){
        JTabbedPane tabbedPane = new JTabbedPane();

        //creating headers
        JPanel winHeader = new JPanel(new GridLayout(1,3));
        winHeader.add(new JLabel("Przeciwnik"));
        winHeader.add(new JLabel("Bramki strzelone"));
        winHeader.add(new JLabel("Bramki stracone"));

        JPanel drawHeader = new JPanel(new GridLayout(1,3));
        drawHeader.add(new JLabel("Przeciwnik"));
        drawHeader.add(new JLabel("Bramki strzelone"));
        drawHeader.add(new JLabel("Bramki stracone"));

        JPanel lostHeader = new JPanel(new GridLayout(1,3));
        lostHeader.add(new JLabel("Przeciwnik"));
        lostHeader.add(new JLabel("Bramki strzelone"));
        lostHeader.add(new JLabel("Bramki stracone"));

        //creating 'final' panels
        JPanel winMatchesPanel = new JPanel(new BorderLayout());
        JPanel drawMatchesPanel = new JPanel(new BorderLayout());
        JPanel lostMatchesPanel = new JPanel(new BorderLayout());

        //creating panels that will have matches inside
        JPanel elementsWinPanel = new JPanel();
        BoxLayout elementsWinPanelLayout = new BoxLayout(elementsWinPanel, BoxLayout.PAGE_AXIS);
        elementsWinPanel.setLayout(elementsWinPanelLayout);

        JPanel elementsDrawPanel = new JPanel();
        BoxLayout elementsDrawPanelLayout = new BoxLayout(elementsDrawPanel, BoxLayout.PAGE_AXIS);
        elementsDrawPanel.setLayout(elementsDrawPanelLayout);

        JPanel elementsLostPanel = new JPanel();
        BoxLayout elementsLostPanelLayout = new BoxLayout(elementsLostPanel, BoxLayout.PAGE_AXIS);
        elementsLostPanel.setLayout(elementsLostPanelLayout);

        //initalizing goals number
        int current_goals = 0, other_goals = 0;

        //filling elementsPanels with won/draw/lost matches
        for(Match match : matches){
            String[] goals = match.score.split(":");
            //this panel will consist match data
            JPanel data = new JPanel(new GridLayout(1, 3));
            //checking if current team is first or second one to secure data correctness
            if(match.firstTeamId == teamIndex){
                current_goals = Integer.parseInt(goals[0]);
                other_goals = Integer.parseInt(goals[1]);
                data.add(new JLabel(match.secondTeamName));
            } else if(match.secondTeamId == teamIndex) {
                current_goals = Integer.parseInt(goals[1]);
                other_goals = Integer.parseInt(goals[0]);
                data.add(new JLabel(match.firstTeamName));
            }

            data.add(new JLabel(String.valueOf(current_goals)));
            data.add(new JLabel(String.valueOf(other_goals)));

            //checking who is the winner, to select which is the correct panel for this data panel
            if(current_goals > other_goals) elementsWinPanel.add(data);
            else if (current_goals == other_goals) elementsDrawPanel.add(data);
            else if (current_goals < other_goals) elementsLostPanel.add(data);
        }

        //creating scroll panes
        JScrollPane winScrollPane = new JScrollPane(elementsWinPanel);
        JScrollPane drawScrollPane = new JScrollPane(elementsDrawPanel);
        JScrollPane lostScrollPane = new JScrollPane(elementsLostPanel);

        winScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        winScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        drawScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        drawScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        lostScrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        lostScrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        //determining position of panels
        winMatchesPanel.add(winHeader, BorderLayout.PAGE_START);
        winMatchesPanel.add(winScrollPane, BorderLayout.CENTER);

        drawMatchesPanel.add(drawHeader, BorderLayout.PAGE_START);
        drawMatchesPanel.add(drawScrollPane, BorderLayout.CENTER);

        lostMatchesPanel.add(lostHeader, BorderLayout.PAGE_START);
        lostMatchesPanel.add(lostScrollPane, BorderLayout.CENTER);

        tabbedPane.add("Wygrane", winMatchesPanel);
        tabbedPane.add("Zremisowane", drawMatchesPanel);
        tabbedPane.add("Przegrane", lostMatchesPanel);

        return tabbedPane;
    }
}
