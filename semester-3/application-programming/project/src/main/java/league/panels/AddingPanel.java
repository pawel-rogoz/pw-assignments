package league.panels;

import league.conectivity.DataProvider;
import league.conectivity.InputData;
import league.types.Indexer;
import org.apache.commons.lang3.StringUtils;
import org.javatuples.Pair;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedList;

public class AddingPanel extends LeaguePanel implements ItemListener {
    /**
     *  Class AddingPanel is a panel that allows user to add new entities(player, match, team, league) to the
     *  application by providing input fields and a submit button.
     *  It contains several panels, one for each type of entity and a ComboBox to switch between them.
     *  It uses CardLayout to switch between panels and DataProvider to communicate with the database.
     *
     */

    private final CardLayout cardLayout;
    private final JPanel cardContainer;
    private final JComboBox actionsBox;
    String[] layoutsNames;
    InputsPanel newPlayerPanel, newMatchPanel, newLeaguePanel, newTeamPanel;
    private DataProvider dataProvider = null;



    public AddingPanel(){
        /**
         * Constructor for the AddingPanel class.
         * It creates a card layout with 4 input panels for adding new entities(player, match, team, league)
         * and a combobox to switch between them.
         */

        //ARRAYS CREATION
        String[] actions = new String[]{
                "Dodaj nowego zawodnika do drużyny.",
                "Dodaj nowy mecz do obecnej ligi.",
                "Utwórz nową drużynę.",
                "Utwórz nową ligę."
        };
        layoutsNames = new String[]{"newPlayerPanel", "newMatchPanel",  "newTeamPanel",  " newLeaguePanel"};

        //CONTAINERS CREATIONS:
        createInputsPanels();

        //CARD LAYOUT CREATION
        cardLayout = new CardLayout();
        cardContainer = new JPanel(cardLayout);

        cardContainer.add(layoutsNames[0], newPlayerPanel);
        cardContainer.add(layoutsNames[1], newMatchPanel);
        cardContainer.add(layoutsNames[2], newTeamPanel);
        cardContainer.add(layoutsNames[3], newLeaguePanel);

        //COMBOBOX CREATION
        actionsBox = new JComboBox(actions);

        //ELEMENTS ADDITION
        setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));
        add(actionsBox);
        add(cardContainer);

        //SETTING LISTENERS AND FINISHING:
        actionsBox.addItemListener(this);
        String[] countries = indexerToStrings(DataProvider.getCountries());
        String[] stadiums = indexerToStrings(DataProvider.getStadiums());
        newPlayerPanel.changeLeague(new String[][]{null, countries});
        newMatchPanel.changeLeague(new String[][]{null, null, stadiums});
        newTeamPanel.changeLeague(new String[][]{countries});
        actionsBox.setSelectedIndex(3);
    }

    @Override
    public void changeLeague(DataProvider dataProvider) {
        /**
         * This method is called when there is a need to update the panel with new information from the database
         * @param dataProvider : Instance of the DataProvider class, used to retrieve data from the database
         */
        this.dataProvider = dataProvider;
        String[] teamsNames = indexerToStrings(dataProvider.getTeams());

        newPlayerPanel.changeLeague(new String[][]{teamsNames, null});
        newMatchPanel.changeLeague(new String[][]{teamsNames, teamsNames, null});
    }

    @Override
    public void itemStateChanged(ItemEvent itemEvent) {
        /**
         * This method is called when the user selects a different item in the combobox,
         * it changes the displayed panel based on the selected item
         * */

        if(itemEvent.getStateChange() == ItemEvent.SELECTED){
            int index = actionsBox.getSelectedIndex();
            if(dataProvider == null && (index == 0 || index == 1 || index == 2)) {
                JOptionPane.showMessageDialog(this,
                        "Aby wybrać tą kartę należy najpierw wybrać ligę z górnego menu.",
                        "Niewybrana liga", JOptionPane.WARNING_MESSAGE);
                actionsBox.setSelectedIndex(3);
            }
            else
                cardLayout.show(cardContainer, layoutsNames[index]);
        }
    }

    private static String[] indexerToStrings(Indexer [] indexers){
        LinkedList<String> resultList= new LinkedList<String>();
        for (Indexer indexer : indexers)
            resultList.add(indexer.toString());

        return resultList.toArray(new String[resultList.size()]);
    }
    private static Indexer findIndexer(Indexer [] indexers, String name){
        for (Indexer indexer : indexers)
            if(name.equals(indexer.toString()))
                return indexer;

        return null;
    }

    private void createInputsPanels(){
        newPlayerPanel = new InputsPanel(
                new String[]{"Imię", "Nazwisko", "Data urodzenia (format YYYY-MM-YY)"},
                new String[]{"Podaj wzrost", "Podaj wage"},
                new String[]{"Wybierz drużynę", "Wybierz kraj pochodzena"},
                "Wprowadz zawodnika do systemu",
                25,
                15,
                new InputsPanel.Validator() {
                    @Override
                    public Pair<String, Pair<int[], String[]>> check(String[] textFieldsValues, int[] spinnersValues, String[] autoComboBoxesValues) {
                        String name = textFieldsValues[0], lastName = textFieldsValues[1], birthdayS = textFieldsValues[2];
                        int height = spinnersValues[0], weight = spinnersValues[1];
                        String selectedTeam = autoComboBoxesValues[0], selectedCountry = autoComboBoxesValues[1];

                        if(!StringUtils.isAlphaSpace(name)) return new Pair<>("Nieprawidłowe imię!", null);
                        if(!StringUtils.isAlphaSpace(lastName)) return new Pair<>("Nieprawidłowe nazwisko!", null);
                        try{
                            LocalDate.parse(birthdayS, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        }catch (Exception e){
                            return  new Pair<>("Nie rozumiem tej daty!", null);
                        }

                        if(height < 100 || height > 250)
                            return new Pair<>("Wzrost zawodnika musi należeć do <100, 250>", null);
                        if(weight < 30 || weight > 225)
                            return new Pair<>("Waga zawodnika musi należeć do <30, 225>", null);


                        Indexer team = findIndexer(dataProvider.getTeams(), selectedTeam);
                        if(team == null) return new Pair<>("Wybierz istniejącą drużynę!", null);
                        Indexer country = findIndexer(DataProvider.getCountries(), selectedCountry);
                        if(country == null) return new Pair<>("Wybierz istniejący kraj!", null);

                        System.out.println("Do systemu zostanie wprowadzony zawodnik: \n" +
                                "imie: " + name + ", nazwisko: " + lastName + "\n" +
                                "data ur: " + birthdayS + ", wzrost " + height + ", waga" + weight + "\n"
                                + "drużyna (id / name): " + team.toIndex() + "/" +  team.toString() + "\n" +
                                "kraj (id / name" + country.toIndex() + " / " + country.toString()
                        );

                        return new Pair<>(null, new Pair<>(
                                new int[] {height, weight},
                                new String[]{name, lastName, birthdayS, country.toString(), team.toString()}
                        ));
                    }

                    @Override
                    public boolean insertData(int[] i, String[] s) {
                        return InputData.inputPlayer(i[0], i[1], s[0], s[1], s[2], s[3], s[4]);
                    }
                }
        );

        newMatchPanel = new InputsPanel(
                new String[]{"Data meczu (format YYYY-MM-YY)"},
                new String[]{"Bramki drużyny pierwszej", "Bramki drużyny drugiej"},
                new String[]{"Wybierz pierwszą drużynę", "Wybierz drugą drużynę", "Wybierz stadion"},
                "Dodaj nowy mecz do ligi.",
                25,
                15,
                new InputsPanel.Validator() {
                    @Override
                    public Pair<String, Pair<int[], String[]>> check(String[] textFieldsValues, int[] spinnersValues, String[] autoComboBoxesValues) {
                        String dateS = textFieldsValues[0];
                        int firstTeamGoals = spinnersValues[0], secondTeamGoals = spinnersValues[1];
                        String firstTeamS = autoComboBoxesValues[0], secondTeamS = autoComboBoxesValues[1],
                                stadionS = autoComboBoxesValues[2];

                        try{
                            LocalDate.parse(dateS, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        }catch (Exception e){
                            return new Pair<>("Nie rozumiem tej daty!", null);
                        }

                        if(firstTeamGoals<0 || firstTeamGoals>25)
                            return new Pair<>("Aż tyle bramek strzeliła drużyna pierwsza?", null);
                        if(secondTeamGoals<0 || secondTeamGoals>25)
                            return new Pair<>("Aż tyle bramek strzeliła drużyna druga?", null);

                        Indexer firstTeam = findIndexer(dataProvider.getTeams(), firstTeamS);
                        if(firstTeam == null) return new Pair<>("Wybierz istniejącą pierwszą drużynę", null);
                        Indexer secondTeam = findIndexer(dataProvider.getTeams(), secondTeamS);
                        if(secondTeam == null) return new Pair<>("Wybierz istniejącą drugą drużynę", null);
                        if(firstTeam.toIndex() == secondTeam.toIndex())
                            return new Pair<>("Drużyna gra sama z sobą?", null);

                        Indexer stadion = findIndexer(DataProvider.getStadiums(), stadionS);
                        if(stadion == null) return new Pair<>("Wybierz istniejący stadion.", null);

                        System.out.println("Do systemu zostanie wprowadzony taki mecz: \n" +
                                "data: " + dateS + "\n" +
                                "bramki pierwszej drużyny: " + firstTeamGoals + ", bramkiDrugiej " + secondTeamGoals + "\n" +
                                "drużyna 1 (id / name): " + firstTeam.toIndex() + "/" +  firstTeam.toString() + "\n" +
                                "drużyna 2 (id / name): " + secondTeam.toIndex() + "/" +  secondTeam.toString() + "\n" +
                                "stadion(id / name): " + stadion.toIndex() + "/" +  stadion.toString()
                        );

                        return new Pair<>(null, new Pair<>(
                                new int[] {firstTeamGoals, secondTeamGoals, dataProvider.getLeagueId()},
                                new String[]{dateS, firstTeam.toString(), secondTeam.toString(), stadion.toString()}
                        ));
                    }

                    @Override
                    public boolean insertData(int[] i, String[] s) {
                        return InputData.inputMatch(i[0], i[1], i[2], s[0], s[1], s[2], s[3]);
                    }
                }
        );


        newTeamPanel = new InputsPanel(
                new String[]{"Nazwa drużyny", "Akronim drużyny"},
                null,
                new String[]{"Wybierz kraj pochodzenia"},
                "Utwórz nową drużynę.",
                25,
                0,
                new InputsPanel.Validator() {
                    @Override
                    public Pair<String, Pair<int[], String[]>> check(String[] textFieldsValues, int[] spinnersValues, String[] autoComboBoxesValues) {
                        String teamName = textFieldsValues[0], teamAcronym = textFieldsValues[1];
                        String countryS = autoComboBoxesValues[0];

                        Indexer country = findIndexer(DataProvider.getCountries(), countryS);
                        if(country == null) return new Pair<>("Wybierz kraj z listy.", null);

                        System.out.println("Wprowadzone zostana te dane:\n" +
                                "nazwa drużyny: " + teamName + ", akronim: " + teamAcronym + "\n" +
                                "kraj poch. (id/nazwa): " + country.toIndex() + " / " + country.toString()
                        );

                        return new Pair<>(null, new Pair<>(
                                new int[]{dataProvider.getLeagueId()},
                                new String[]{teamName, teamAcronym, country.toString()}
                        ));
                    }

                    @Override
                    public boolean insertData(int[] i, String[] s) {
                        return InputData.inputTeam(i[0] ,s[0], s[1], s[2]);
                    }
                }
        );

        newLeaguePanel = new InputsPanel(
                new String[]{"Nazwa ligi"},
                null,
                null,
                "Dodaj nowa lige",
                25,
                0,
                new InputsPanel.Validator() {
                    @Override
                    public Pair<String, Pair<int[], String[]>> check(String[] textFieldsValues, int[] spinnersValues, String[] autoComboBoxesValues) {
                        return new Pair<>(null, new Pair<>(null, new String[]{textFieldsValues[0]}));
                    }

                    @Override
                    public boolean insertData(int[] i, String[] s) {
                        return InputData.inputLeague(s[0]);
                    }
                }
        );
    }
}
