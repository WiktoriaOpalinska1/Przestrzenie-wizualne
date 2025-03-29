import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;
import processing.video.*;

// Size of each cell in the grid
int cellSize = 20;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;

// NyAR4psg variables
MultiMarker nya;
boolean markerDetected = false;

// Red pulse variables
float pulseIntensity = 0;
float pulseSpeed = 0.1;
boolean increasing = true;

void setup() {
  size(640, 480, P3D);
  frameRate(30);
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);

  // Initialize the webcam
  video = new Capture(this, width, height);
  video.start();

  // Initialize NyAR4psg
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro", 80); // Add a marker pattern to detect
}

void draw() {
  if (video.available()) {
    video.read();
  }

  // Update the AR marker detection
  nya.detect(video);
  markerDetected = nya.isExist(0); // Check if the marker is detected

  // Update pulse intensity
  if (markerDetected) {
    if (increasing) {
      pulseIntensity += pulseSpeed;
      if (pulseIntensity >= 1.0) {
        pulseIntensity = 1.0;
        increasing = false;
      }
    } else {
      pulseIntensity -= pulseSpeed;
      if (pulseIntensity <= 0.3) {
        pulseIntensity = 0.3;
        increasing = true;
      }
    }
  } else {
    pulseIntensity = 0;
  }

  // Display the webcam feed with effect
  if (markerDetected) {
    // Create disturbing red pulse effect
    video.loadPixels();
    PImage redImage = createImage(video.width, video.height, RGB);
    redImage.loadPixels();
    
    for (int i = 0; i < video.pixels.length; i++) {
      color c = video.pixels[i];
      // Calculate grayscale value
      float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
      // Apply pulsing red effect
      float r = gray + (255 - gray) * pulseIntensity;
      float g = gray * (1.0 - pulseIntensity * 0.9);
      float b = gray * (1.0 - pulseIntensity * 0.9);
      redImage.pixels[i] = color(r, g, b);
    }
    redImage.updatePixels();
    
    // Add some distortion
    pushMatrix();
    translate(width/2, height/2);
    scale(1.0 + pulseIntensity * 0.05);
    translate(-width/2, -height/2);
    image(redImage, 0, 0);
    popMatrix();
    
    // Add flickering red overlay
    if (frameCount % 5 == 0) { // Random flicker
      fill(255, 0, 0, 30 * pulseIntensity);
      rect(0, 0, width, height);
    }
  } else {
    // Show normal image when no marker is detected
    image(video, 0, 0);
  }
}

void captureEvent(Capture c) {
  c.read();
}