import processing.pdf.*;

void setup(){
  size(640, 480,P3D);
  colorMode(RGB, 255);
  bgColor = color(0); 
  GUI_setup();
  icons_setup();
}

void draw() {
  draw_icons();
}
