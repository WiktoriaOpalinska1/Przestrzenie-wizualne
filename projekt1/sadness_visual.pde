import jp.nyatla.nyar4psg.*;
import jp.nyatla.nyar4psg.utils.*;
import processing.video.*;

Capture video;
MultiMarker nya;
boolean markerDetected = false;

// Effect parameters
float bwEffect = 0;
final float FADE_SPEED = 0.05;

void setup() {
  size(640, 480);
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
    bwEffect = min(bwEffect + FADE_SPEED, 1.0);
  } else {
    bwEffect = max(bwEffect - FADE_SPEED, 0.0);
  }

  if (bwEffect > 0) {
    applyBlackWhiteEffect();
  } else {
    image(video, 0, 0);
  }
}

void applyBlackWhiteEffect() {
  // Create graphics buffer for effects
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  
  // Show original video
  pg.image(video, 0, 0);
  
  // Apply black and white effect
  if (bwEffect > 0) {
    pg.loadPixels();
    for (int i = 0; i < pg.pixels.length; i++) {
      color c = pg.pixels[i];
      // Calculate grayscale value (luminosity method)
      float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
      // Blend between color and B&W based on effect strength
      float r = lerp(red(c), gray, bwEffect);
      float g = lerp(green(c), gray, bwEffect);
      float b = lerp(blue(c), gray, bwEffect);
      pg.pixels[i] = color(r, g, b);
    }
    pg.updatePixels();
  }
  
  pg.endDraw();
  
  // Render final result
  image(pg, 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}