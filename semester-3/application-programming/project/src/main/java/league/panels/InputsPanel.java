package league.panels;

import league.autocomplete.AutoComboBox;
import org.javatuples.Pair;
import org.javatuples.Triplet;

import javax.swing.*;

class InputsPanel extends JPanel {
    /**
     *  Class InputsPanel is a panel that contains several inputs such as textfields, spinners, autocomplete comboboxes,
     *  and a button that is used to submit the data entered in the inputs.
     *  It checks if the filled data is correct, and it calls the validator method to check that.
     *  It also has a JLabel which will be used to show messages to the user.
     */
    private JTextField[] textFields = null;
    private JSpinner[] spinners = null;
    private AutoComboBox[] autoComboBoxes;
    private JButton button;
    private final Validator validator;
    private final String[] textFieldsLabels, spinnersLabels, autoComboBoxesLabels;

    public InputsPanel(String[] textFieldsLabels, String[] spinnersLabels, String[] autoComboBoxesLabels,
                       String buttonLabel, int textFieldsWidth, int spinnersWidth, Validator validator){
        /**
         * Constructor for the InputsPanel class. It creates several inputs (textfields, spinners, autocomplete comboboxes)
         * and a submit button, with labels passed in as arguments.
         * @param textFieldsLabels : String array, representing labels for text fields. For each label a textField will
         *        be generated. (So number of TextFields is equal to length of textFieldsLabels). If there should be no
         *        textFields in a panel, this arg should be null.
         * @param spinnersLabels : String array, representing labels for spinners. For each label a spinner will
         *         be generated. Spinner will accept only positive integers. (So number of Spinners is equal to length
         *         of spinnersLabels). If there should be no spinners in a panel, this arg should be null.
         * @param autoComboBoxesLabels : String array, representing labels for autocomplete comboboxes. For each label a
         *        autoComboBox will be generated. (So number of comboboxes is equal to length of autoComboBoxesLabels).
         *        If there should be no textFields in a panel, this arg should be null.
         * @param buttonLabel : String, representing label for submit button
         * @param textFieldsWidth : int, representing width of text fields (in columns)
         * @param spinnersWidth : int, representing width of spinners (in columns)
         * @param validator : instance of a class that implements the Validator interface,
         *        used to check the correctness of the filled data, and uploading the data. See validator interface
         *        documentation strings for more.
         */
        this.textFieldsLabels = textFieldsLabels;
        this.spinnersLabels = spinnersLabels;
        this.autoComboBoxesLabels = autoComboBoxesLabels;
        this.validator = validator;
        setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));

        if(textFieldsLabels != null){
            textFields = new JTextField[textFieldsLabels.length];
            for(int i = 0; i<textFieldsLabels.length; i++){
                textFields[i] = new JTextField(textFieldsWidth);
                add(createInputPanel(textFieldsLabels[i], textFields[i]));
            }
        }
        if(spinnersLabels != null){
            spinners = new JSpinner[spinnersLabels.length];
            for(int i = 0; i<spinnersLabels.length; i++){
                spinners[i] = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
                ((JSpinner.DefaultEditor) spinners[i].getEditor()).getTextField().setColumns(spinnersWidth);
                add(createInputPanel(spinnersLabels[i], spinners[i]));
            }
        }
        if(autoComboBoxesLabels != null){
            autoComboBoxes = new AutoComboBox[autoComboBoxesLabels.length];
            for(int i = 0; i<autoComboBoxesLabels.length; i++){
                autoComboBoxes[i] = new AutoComboBox();
                autoComboBoxes[i].setPrototypeDisplayValue("To jest naprawde długi tekst, napr");
                add(createInputPanel(autoComboBoxesLabels[i], autoComboBoxes[i]));
            }
        }

        button = new JButton(buttonLabel);
        button.addActionListener(action -> {
            //CHECK IF EVERYTHING IS FILLED
            Pair<String, Triplet<String[], int[], String[]>> filledCheck = checkIfFilled();
            if(filledCheck.getValue0() != null){
                JOptionPane.showMessageDialog(this, filledCheck.getValue0(),
                        "Nieprawidłowe dane", JOptionPane.WARNING_MESSAGE);
                return;
            }

            //CHECK IF DATA IS CORRECT
            Triplet<String[], int[], String[]> inputsValues = filledCheck.getValue1();
            Pair<String, Pair<int[], String[]>> validationCheck =
                    validator.check(inputsValues.getValue0(), inputsValues.getValue1(), inputsValues.getValue2());

            //SHOW MESSAGE INDICATING WRONG DATA OR TRY TO INSERT DATA TO DATABASE
            if(validationCheck.getValue0() == null){
                button.setEnabled(false);
                JLabel messageLabel = new JLabel("Prosze czekać, wprowadzam dane.");
                add("messageLabel", messageLabel);
                messageLabel.setVisible(true);
                Pair<int[], String[]> dataToInsert = validationCheck.getValue1();
                boolean success = validator.insertData(dataToInsert.getValue0(), dataToInsert.getValue1());
                if(success) {
                    JOptionPane.showMessageDialog(this, "Dane wprowadzone pomyślnie,",
                            "Sukces", JOptionPane.INFORMATION_MESSAGE);
                }else {
                    JOptionPane.showMessageDialog(this,
                            "Wystąpił błąd przy wprowadzaniu danych. Sprawdź połączenie i próbuj ponownie póżniej.",
                            "Porażka", JOptionPane.INFORMATION_MESSAGE);
                }

                messageLabel.setVisible(false);
                remove(messageLabel);
                button.setEnabled(true);

            }else{
                JOptionPane.showMessageDialog(this, validationCheck.getValue0(),
                        "Nieprawidłowe dane", JOptionPane.WARNING_MESSAGE);
            }
        });
        add(button);
    }

    public void changeLeague(String[][] autoComboBoxesItems){
        for(int i =0; i< autoComboBoxesItems.length; i++){
            if(autoComboBoxesItems[i] != null)
                autoComboBoxes[i].setKeyWord(autoComboBoxesItems[i]);
        }
    }

    public interface Validator{

        /**
         * Validator interface is used to check the correctness of the filled data
         * check method returns Pair
         */

        /**
         * this method is used to check if all values are correct and returns pair
         * first value is a string with a message that some field is incorect message and null if everything is correct.
         * (If first value is null, then this panel tries to upload data)
         * second value is Triplet containing 1 array of ints 1 array of strings (spinners, textfields, and
         * autocomplete comboboxes).
         * Those three arrays are then passed to method "insertData", which method uploads new data to database.
         *
         * @param textFieldsValues values of consecutive textFields. Before calling this method it will checked that no
         *        of this String is null or empty.
         * @param spinnersValues values of consecutive Spinners. Before calling this method it will checked that no
         *        of this ints are non-negative.
         * @param autoComboBoxesValues alues of consecutive autoComboBoxes. Before calling this method it will checked
         *        that no of this String is null or empty.
         */
        public Pair<String, Pair<int[], String[]>> check(String[] textFieldsValues, int[] spinnersValues, String[] autoComboBoxesValues);


        /**
         * @param ints array of ints to insert to database (the one returned by method check of the same object)
         * @param strings array of strings to insert to database (the one returned by method check of the same object)
         * @return true if data was uploaded sucessfully, false if there was an error while trying to upload data
         * (for example internet loss)
         */
        public boolean insertData(int[] ints, String[] strings);
    }



    private Pair<String, Triplet<String[], int[], String[]>> checkIfFilled(){
        /**
         * this method is used to check if all fields are filled and returns pair
         * first value is a string with a message that some field is missing nd null if everything is correct.
         * (If first value is null, then this panel call method check of Validator to make sure that alle values are
         * correct (this method checks if evr is filled, validator if is correct)
         * second value is Triplet containing 3 arrays of strings (textfields, spinners and autocomplete comboboxes) if
         * everything is correct and null if some value is incorrect.
         */
        String[] textFieldsValues = null, autoComboBoxesValues = null;
        int[] spinnersValues = null;

        if(textFieldsLabels != null){
            textFieldsValues = new String[textFields.length];
            for (int i = 0; i<textFields.length; i++){
                String text = textFields[i].getText();
                if(text.isEmpty())
                    return new Pair<>("Wypełnij pole o etykiecie:\n\"" + textFieldsLabels[i] + "\"" , null);
                textFieldsValues[i] = text;
            }
        }

        if(spinnersLabels != null){
            spinnersValues = new int[spinners.length];
            for (int i = 0; i<spinners.length; i++){
                try{
                    spinnersValues[i] = Integer.parseInt(spinners[i].getValue().toString());
                }catch (Exception e){
                    return new Pair<>("Wprowadź prawidłową wartość w polu o etykiecie:\n\"" + spinnersLabels[i] + "\"" , null);
                }
            }
        }

        if(autoComboBoxesLabels != null){
            autoComboBoxesValues = new String[autoComboBoxes.length];
            for (int i = 0; i<autoComboBoxes.length; i++){
                Object selectedItem = autoComboBoxes[i].getSelectedItem();
                if(selectedItem == null)
                    return new Pair<>("Wybierz coś z listy w pole o etykiecie:\n\"" + autoComboBoxesLabels[i] + "\"" , null);
                autoComboBoxesValues[i] = selectedItem.toString();
            }
        }

        return new Pair<>(null, new Triplet<>(textFieldsValues, spinnersValues, autoComboBoxesValues));
    }

    private static JPanel createInputPanel(String labelText, JComponent inputComponent){
        JPanel panel = new JPanel();
        JLabel label = new JLabel(labelText);

        inputComponent.setMaximumSize(inputComponent.getPreferredSize());
        label.setMaximumSize(label.getPreferredSize());

        panel.setLayout(new BoxLayout(panel, BoxLayout.LINE_AXIS));
        panel.add(label);
        panel.add(inputComponent);

        panel.setMaximumSize(panel.getPreferredSize());
        return panel;
    }
    

}
