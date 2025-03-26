import controlP5.*;

ControlP5 cp5;
int bgColor;

void setup() {
  size(800, 600);
  bgColor = color(0);
  
  cp5 = new ControlP5(this);
  int buttonWidth = 150;
  int buttonHeight = 40;
  int startX = width - buttonWidth - 20;
  int startY = 50;
  int spacing = 20;
  
  cp5.addButton("Domyslny")
     .setPosition(startX, startY)
     .setSize(buttonWidth, buttonHeight)
     .setColorBackground(color(0))
     .getCaptionLabel().setFont(createFont("Arial", 16));
  
  cp5.addButton("Milosc")
     .setPosition(startX, startY + (buttonHeight + spacing))
     .setSize(buttonWidth, buttonHeight)
     .setColorBackground(color(255, 105, 180))
     .getCaptionLabel().setFont(createFont("Arial", 16));
  
  cp5.addButton("Radosc")
     .setPosition(startX, startY + 2 * (buttonHeight + spacing))
     .setSize(buttonWidth, buttonHeight)
     .setColorBackground(color(0, 255, 0))
     .getCaptionLabel().setFont(createFont("Arial", 16));
  
  cp5.addButton("Smutek")
     .setPosition(startX, startY + 3 * (buttonHeight + spacing))
     .setSize(buttonWidth, buttonHeight)
     .setColorBackground(color(169, 169, 169))
     .getCaptionLabel().setFont(createFont("Arial", 16));
  
  cp5.addButton("Niepokoj")
     .setPosition(startX, startY + 4 * (buttonHeight + spacing))
     .setSize(buttonWidth, buttonHeight)
     .setColorBackground(color(139, 0, 0))
     .getCaptionLabel().setFont(createFont("Arial", 16));
}

void draw() {
  background(bgColor);
  fill(50); // Ciemnoszary sidebar
  noStroke();
  rect(width - 200, 0, 200, height);
}

void controlEvent(ControlEvent event) {
  String buttonName = event.getController().getName();
  
  if (buttonName.equals("Domyslny")) {
    bgColor = color(0);
  } else if (buttonName.equals("Milosc")) {
    bgColor = color(255, 105, 180);
  } else if (buttonName.equals("Radosc")) {
    bgColor = color(0, 255, 0);
  } else if (buttonName.equals("Smutek")) {
    bgColor = color(169, 169, 169);
  } else if (buttonName.equals("Niepokoj")) {
    bgColor = color(139, 0, 0);
  }
}
