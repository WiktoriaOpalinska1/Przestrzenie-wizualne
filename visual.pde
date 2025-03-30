void visual_setup(){
  cols = width / cellSize;
  rows = height / cellSize;
}

void apply_effects() {
  if (cam.available()) {
    cam.read();
  }
  
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);

  for (int i = 0; i < 4; i++) {
    if (!nya.isExist(i)) {
      continue;
    }
    
    nya.beginTransform(i);
    
    if (i == 0 && icon_set == 1) {
      drawMilosc();
      applyLoveEffect();
    } else if (i == 1 && icon_set == 1) {
      drawRadosc();
      applySunshineEffect();
    } else if (i == 0 && icon_set == 2) {
      drawNiepokoj();
      applyAnxietyEffect();
    } else if (i == 1 && icon_set == 2) {
      drawSmutek();
      applyBlackWhiteEffect();
    }
     playEffectSound(icon_set, i);
    
    nya.endTransform();
  }
}

void applySunshineEffect() {
  // Create graphics buffer for effects
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.image(cam, 0, 0);
  
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

void applyLoveEffect() {
  if (cam.available()) {
    cam.read();
  }

  // Update the AR marker detection
  nya.detect(cam);
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
    cam.loadPixels();
    PImage pinkImage = createImage(cam.width, cam.height, RGB);
    pinkImage.loadPixels();
    
    for (int i = 0; i < cam.pixels.length; i++) {
      color c = cam.pixels[i];
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
    image(cam, 0, 0);
  }
}

void applyBlackWhiteEffect() {
  // Create graphics buffer for effects
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  
  // Show original video
  pg.image(cam, 0, 0);
  
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

void applyAnxietyEffect() {
  if (cam.available()) {
    cam.read();
  }

  // Update the AR marker detection
  nya.detect(cam);
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
    cam.loadPixels();
    PImage redImage = createImage(cam.width, cam.height, RGB);
    redImage.loadPixels();
    
    for (int i = 0; i < cam.pixels.length; i++) {
      color c = cam.pixels[i];
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
    image(cam, 0, 0);
  }
}


void captureEvent(Capture c) {
  c.read();
}
