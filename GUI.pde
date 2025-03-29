import controlP5.*;

ControlP5 cp5;
int bgColor;
int icon_set = 1;
Button b1, b2;

void GUI_setup(){
cp5 = new ControlP5(this);
  int buttonWidth1 = 150;
  int buttonHeight = 35;
  int startX = width/2;
  int startY = height - buttonHeight - 20;
  
  b1 = (Button) cp5.addButton("Stan pozytywny")
     .setPosition(startX - 180, startY)
     .setSize(buttonWidth1, buttonHeight)
     .setColorBackground(color(0))  
     .setColorForeground(color(255)); 
  
  b1.getCaptionLabel().setFont(createFont("Arial", 14));

  b2 = (Button) cp5.addButton("Stan negatywny")
     .setPosition(startX + 30, startY)
     .setSize(buttonWidth1, buttonHeight)
     .setColorBackground(color(0))
     .setColorForeground(color(255));

  b2.getCaptionLabel().setFont(createFont("Arial", 14));
  
}
void controlEvent(ControlEvent event) {
  String buttonName = event.getController().getName();

  // Resetujemy oba przyciski do domyślnych kolorów
  b1.setColorBackground(color(0));
  b1.setColorForeground(color(255));
  b2.setColorBackground(color(0));
  b2.setColorForeground(color(255));

  // Zmieniamy kolor tylko dla aktywnego przycisku
  if (buttonName.equals("Stan pozytywny")) {
    icon_set = 1;
    b1.setColorBackground(color(150)); // Szary
    b1.setColorForeground(color(0));   // Czarny tekst
  } else if (buttonName.equals("Stan negatywny")) {
    icon_set = 2;
    b2.setColorBackground(color(150));
    b2.setColorForeground(color(0));
  }
}

/*void controlEvent(ControlEvent event) {
  String buttonName = event.getController().getName();
  
 if (buttonName.equals("Stan pozytywny")) {
    icon_set = 1;
    event.getController().setColorBackground(color(150));
    event.getController().setColorForeground(color(0));
  } else if (buttonName.equals("Stan negatywny")) {
    icon_set = 2;
    event.getController().setColorBackground(color(150));
    event.getController().setColorForeground(color(0));
  }
}*/
