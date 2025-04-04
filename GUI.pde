/*
  Osoba odpowiedzialna: Wiktoria.
  
  Co znajduje się w tym pliku:
  - Ustawienia dla przycisków zmieniających tryb.
  - Obsługa eventów (naciśnięcie przycisków).
  
  Wykorzystane biblioteki:
  - ControlP5 - jedna z podstawowych bibliotek do tworzenia GUI w Processingu
*/


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

  b1.setColorBackground(color(0));
  b1.setColorForeground(color(255));
  b2.setColorBackground(color(0));
  b2.setColorForeground(color(255));

  if (buttonName.equals("Stan pozytywny")) {
    icon_set = 1;
    b1.setColorBackground(color(150)); 
    b1.setColorForeground(color(0));  
  } else if (buttonName.equals("Stan negatywny")) {
    icon_set = 2;
    b2.setColorBackground(color(150));
    b2.setColorForeground(color(0));
  }
}
