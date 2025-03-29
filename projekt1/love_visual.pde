import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;
import processing.video.*;

// Size of each cell in the grid
int cellSize = 20;
// Variable for capture device
Capture video;

// NyAR4psg variables
MultiMarker nya;
boolean markerDetected = false;

// Romantic effect variables
float loveGlow = 0;
float glowSpeed = 0.05;
ArrayList<Heart> hearts = new ArrayList<Heart>();

void setup() {
  size(640, 480, P3D);
  frameRate(30);
  colorMode(RGB, 255, 255, 255, 100);

  // Initialize the webcam
  video = new Capture(this, width, height);
  video.start();

  // Initialize NyAR4psg
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro", 80);
}

void draw() {
  if (video.available()) {
    video.read();
  }

  // Update the AR marker detection
  nya.detect(video);
  markerDetected = nya.isExist(0);

  // Update romantic glow effect
  if (markerDetected) {
    loveGlow = min(loveGlow + glowSpeed, 1.0);
    
    // Occasionally add floating hearts
    if (frameCount % 30 == 0 && hearts.size() < 15) {
      hearts.add(new Heart());
    }
  } else {
    loveGlow = max(loveGlow - glowSpeed, 0.0);
  }

  // Display the webcam feed with effect
  if (loveGlow > 0) {
    // Create pink tinted image
    video.loadPixels();
    PImage pinkImage = createImage(video.width, video.height, RGB);
    pinkImage.loadPixels();
    
    for (int i = 0; i < video.pixels.length; i++) {
      color c = video.pixels[i];
      // Convert to romantic pink tones
      float r = red(c) * 0.5 + 200 * loveGlow;
      float g = green(c) * 0.3 + 100 * loveGlow;
      float b = blue(c) * 0.4 + 150 * loveGlow;
      pinkImage.pixels[i] = color(
        constrain(r, 0, 255), 
        constrain(g, 0, 255), 
        constrain(b, 0, 255)
      );
    }
    pinkImage.updatePixels();
    
    // Apply soft glow
    tint(255, 200 + 55 * loveGlow);
    image(pinkImage, 0, 0);
    noTint();
    
    // Draw floating hearts
    for (int i = hearts.size()-1; i >= 0; i--) {
      Heart h = hearts.get(i);
      h.update();
      h.display();
      if (h.isOffScreen()) {
        hearts.remove(i);
      }
    }
  } else {
    // Show normal image
    image(video, 0, 0);
  }
}

// Heart class for floating hearts
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

void captureEvent(Capture c) {
  c.read();
}