package league.panels;

import league.conectivity.DataProvider;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public abstract class LeagueViewingPanel extends LeaguePanel implements ActionListener{
    /**
     * An abstract class from which all panels (panels with teams, panels with matches, etc.) are derived.
     * changeLeague method is called when there is a need to show new information in the panel. Such as when a new league is chosen
     * or when some data is redownloaded from the database (refresh teams, refresh matches).
     * It's define the overall layout, header and scrollPane for all the derived classes
     */

    protected DataProvider dataProvider;

    private IndexButton firstButton;
    private final JScrollPane scrollPane;
    private final JPanel header;


    public LeagueViewingPanel(String[] columnsNames, String message){
        /**
         * @param columnsNames this is an array of names of all columns
         * @param message Label with this message is shown before the first "changeLeague" method is called.
         * ex: "Here will be a list of teams when the user chooses a league."
         * It also creates header and elementsPanel with message.
         */
        setLayout(new BorderLayout());

        //HEADER CREATION
        header = new JPanel(new GridLayout(1, columnsNames.length));
        for(String columnsName : columnsNames){
            header.add(new JLabel(columnsName));
        }

        //ELEMENTS LIST JPANEL CREATION (the one with box layout)
        JPanel elementsPanel = new JPanel();
        elementsPanel.add(new JLabel(message));
        firstButton = new IndexButton("", 0);//just so a Resize Listener works properly

        //ScrollPaneCreations
        scrollPane = new JScrollPane(elementsPanel);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);


        //FINISH
        add(header, BorderLayout.PAGE_START);
        add(scrollPane, BorderLayout.CENTER);
    }


    public void changeLeague(DataProvider dataProvider){
        /**
         * This method updates the current panel when a new league is selected
         *  or when some data is redownloaded from the database (refresh teams, refresh matches)
         * @param dataProvider a DataProvider object from which new information is obtained
         */
        JPanel elementsPanel = new JPanel();
        this.dataProvider = dataProvider;
        elementsPanel.setLayout(new BoxLayout(elementsPanel, BoxLayout.PAGE_AXIS));

        //RESIZE LISTENER ADDITION
        elementsPanel.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) { adjustBorder(); }

            @Override
            public void componentShown(ComponentEvent e) { adjustBorder(); }
        });

        firstButton = fillElementsPanel(dataProvider, elementsPanel);
        scrollPane.setViewportView(elementsPanel);
    }


    @Override
    public void actionPerformed(ActionEvent actionEvent) {
        /**
         * Overridden method from ActionListener, It will be called when the button is clicked
         * @param actionEvent the event that was fired
         */
        int index = ((IndexButton) actionEvent.getSource()).index;
        launchNewWindow(index);
    }

    /**
     * This method is used to launch a new window when an element in the panel is selected
     * @param index The index of the selected element
     */
    abstract void launchNewWindow(int index);

    /**
     * This method is used to fill the elementsPanel with the appropriate elements from the dataProvider
     * @param dataProvider The DataProvider object from which new elements are obtained
     * @param elementsPanel The JPanel in which the elements are added
     * @return the first button created so that it can be used to adjust the border
     */
    abstract protected IndexButton fillElementsPanel(DataProvider dataProvider, JPanel elementsPanel);


    private void adjustBorder(){
        /**
         * This method will be called when the component is resized or shown,
         *  it adjust the border of the header to match the width of the first button in elementsPanel and the width of the scrollbar
         */

        header.setBorder(BorderFactory.createEmptyBorder(0,0,0,
                firstButton.getWidth() + scrollPane.getVerticalScrollBar().getWidth()));
    }
}
