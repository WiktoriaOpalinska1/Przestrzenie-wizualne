import processing.pdf.*;

void setup(){
  size(640, 480,P3D);
  colorMode(RGB, 255);
  frameRate(30);
  bgColor = color(0); 
  GUI_setup();
  icons_setup();
  visual_setup();
}

void draw() {
  apply_effects();
}
