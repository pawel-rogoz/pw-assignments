package league.panels;

import java.awt.*;

class IndexButton extends Button {
    int index;
    public IndexButton(String text, int index){
        super(text);
        this.index = index;
    }
}
