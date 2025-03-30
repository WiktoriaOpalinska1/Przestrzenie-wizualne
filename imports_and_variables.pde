import controlP5.*;
import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;
import processing.video.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import processing.sound.*;

//GUI
ControlP5 cp5;
int bgColor;
int icon_set = 1;
Button b1, b2;


// Visual
Capture cam;
MultiMarker nya;
boolean markerDetected = false;

// Effects' parameters
float sunEffect = 0;
final float FADE_SPEED = 0.05;
final float WARMTH_INTENSITY = 1.5;
final float SUNLIGHT_GLOW = 1.8;

int cellSize = 20;
float loveGlow = 0;
float glowSpeed = 0.05;
ArrayList<Heart> hearts = new ArrayList<Heart>();

float bwEffect = 0;

int cols, rows;
float pulseIntensity = 0;
float pulseSpeed = 0.1;
boolean increasing = true;

class Heart {
  float x, y;
  float size;
  float speed;
  color heartColor;
  
  Heart() {
    x = random(width);
    y = height + 20;
    size = random(15, 40);
    speed = random(1, 3);
    heartColor = color(
      220 + random(35), 
      50 + random(100), 
      100 + random(100), 
      150 + random(105)
    );
  }
  
  void update() {
    y -= speed;
    x += random(-0.5, 0.5);
  }
  
  void display() {
    noStroke();
    fill(heartColor);
    beginShape();
    vertex(x, y);
    bezierVertex(x - size/2, y - size/2, x - size, y + size/3, x, y + size);
    bezierVertex(x + size, y + size/3, x + size/2, y - size/2, x, y);
    endShape();
  }
  
  boolean isOffScreen() {
    return y < -size;
  }
}


/* Sound attrubutions:
Soft Piano Loop #2 by ispeakwaves -- https://freesound.org/s/384935/ -- License: Attribution 4.0
sitcom type piano loop "bubble piano" by kbrecordzz -- https://freesound.org/s/788980/ -- License: Creative Commons 0
Heartbeat Foley.wav by Kevinflo -- https://freesound.org/s/91257/ -- License: Creative Commons 0
Melancholy Dreamscape by ViraMiller -- https://freesound.org/s/743843/ -- License: Attribution 4.0
*/
