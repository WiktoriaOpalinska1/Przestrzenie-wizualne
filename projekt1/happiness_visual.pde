import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;
import processing.video.*;

Capture video;
MultiMarker nya;
boolean markerDetected = false;

// Sunshine effect parameters
float sunEffect = 0;
final float FADE_SPEED = 0.05;
final float WARMTH_INTENSITY = 1.5;
final float SUNLIGHT_GLOW = 1.8;

void setup() {
  size(640, 480, P2D);
  video = new Capture(this, width, height);
  video.start();
  
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.kanji", 80);
  
  colorMode(RGB, 255);
}

void draw() {
  if (video.available()) {
    video.read();
  }

  nya.detect(video);
  markerDetected = nya.isExist(0);
  
  // Update effect strength
  if (markerDetected) {
    sunEffect = min(sunEffect + FADE_SPEED, 1.0);
  } else {
    sunEffect = max(sunEffect - FADE_SPEED, 0.0);
  }

  if (sunEffect > 0) {
    applySunshineEffect();
  } else {
    image(video, 0, 0);
  }
}

void applySunshineEffect() {
  // Create graphics buffer for effects
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.image(video, 0, 0);
  
  // Apply warm color grading
  pg.loadPixels();
  for (int i = 0; i < pg.pixels.length; i++) {
    color c = pg.pixels[i];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    // Boost red/yellow channels
    r = min(r * (1.0 + sunEffect * 0.7), 255);
    g = min(g * (1.0 + sunEffect * 0.4), 255);
    b = b * (1.0 - sunEffect * 0.3);
    
    // Add golden tint
    float warmth = sunEffect * WARMTH_INTENSITY;
    r = min(r + 30 * warmth, 255);
    g = min(g + 15 * warmth, 255);
    
    pg.pixels[i] = color(r, g, b);
  }
  pg.updatePixels();
  
  // Add sunlight glow
  if (sunEffect > 0.3) {
    pg.blendMode(SCREEN);
    pg.fill(255, 220, 150, 80 * sunEffect);
    pg.noStroke();
    pg.ellipse(width * 0.7, height * 0.3, width * 0.8, width * 0.8);
    pg.blendMode(BLEND);
  }
  
  // Add subtle vignette to focus attention
  pg.fill(0, 0, 0, 30 * sunEffect);
  pg.noStroke();
  pg.beginShape();
  pg.vertex(0, 0);
  pg.vertex(width, 0);
  pg.vertex(width, height);
  pg.vertex(0, height);
  pg.beginContour();
  pg.vertex(width*0.1, height*0.1);
  pg.vertex(width*0.9, height*0.1);
  pg.vertex(width*0.9, height*0.9);
  pg.vertex(width*0.1, height*0.9);
  pg.endContour();
  pg.endShape();
  
  pg.endDraw();
  
  // Render final result
  image(pg, 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}