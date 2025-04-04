/*
  Osoba odpowiedzialna: Kamil (90%), Aleksandra (5%) i Wiktoria (5%)
  
  Co zawiera ten plik:
  - główny kod programu
  - funkcję łączącą efekty wizualne, efekty dźwiękowe i wyświetlanie itemów
  - 4 funkcje odpowiedzialne za efekty dźwiękowe
  
  Wykorzystane biblioteki:
  - Video - obsługa kamery
  - NyARToolkit - obsługa znaczników
  - OpenCV - dodatkowy efekt dla trybu Niepokój
  - PImage i PGraphics - efekty wizualne
  
  UWAGA: jeśli projekt nie uruchamia się, należy zakomentować wskazaną linijkę w apply_effects()
*/

void visual_setup(){
  cols = width / cellSize;
  rows = height / cellSize;
  opencv = new OpenCV(this, width, height);
}


/* 
  Główna funkcja w całym kodzie - odpowiedzialna za uruchamiane właściwych efektów.
  Działanie:
  1. Wczytwanie kamery i rozpoznawanie znaczników.
  2. Rysowanie ikon na znacznikach.
  3. Uruchomienie efektów dźwiękowych
  4. Zastosowanie efektów wizualnych
*/
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
    } else if (i == 1 && icon_set == 1) {
      drawRadosc();
    } else if (i == 0 && icon_set == 2) {
      drawNiepokoj();
    } else if (i == 1 && icon_set == 2) {
      drawSmutek();
    }
    
   playEffectMusic(icon_set, i); // ZAKOMENTOWAĆ W RAZIE NIEPOWODZENIA Z OTWORZENIEM PROJEKTU
  //playEffectSound(icon_set, i); // Funkcja poboczna
    
    nya.endTransform();
  }
  
  
  switch(icon_set) {
    case 1:
      if (nya.isExist(0)) {
        applyLoveEffect();
      }
      if (nya.isExist(1)) {
        sunEffect = 1.0;
        applySunshineEffect();
      }
      break;
    case 2:
      if (nya.isExist(0)) {
        applyAnxietyEffect();
      }
      if (nya.isExist(1)) {
        bwEffect = 1;
        applyBlackWhiteEffect();
      }
      break;
    default:
      break;
  }
}

// Funkcja odpowiedzialna za efekty wizualne dla trybu radość
// Nałożenie ciepłego żółtego koloru na tło i dodanie efektu słońca
void applySunshineEffect() {
 
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.image(cam, 0, 0);
  
  pg.loadPixels();
  for (int i = 0; i < pg.pixels.length; i++) {
    color c = pg.pixels[i];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    r = min(r * (1.0 + sunEffect * 0.7), 255);
    g = min(g * (1.0 + sunEffect * 0.4), 255);
    b = b * (1.0 - sunEffect * 0.3);
    
    float warmth = sunEffect * WARMTH_INTENSITY;
    r = min(r + 30 * warmth, 255);
    g = min(g + 15 * warmth, 255);
    
    pg.pixels[i] = color(r, g, b);
  }
  pg.updatePixels();
  
  if (sunEffect > 0.3) {
    pg.blendMode(SCREEN);
    pg.fill(255, 220, 150, 80 * sunEffect);
    pg.noStroke();
    pg.ellipse(width * 0.7, height * 0.3, width * 0.8, width * 0.8);
    pg.blendMode(BLEND);
  }
  
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
  
  image(pg, 0, 0);
}


// Funkcja odpowiedzialna za efekty wizualne dla trybu miłość
// Nałożenie różowego tła i dodanie unoszących się serc
void applyLoveEffect() {
  if (cam.available()) {
    cam.read();
  }

  nya.detect(cam);
  markerDetected = nya.isExist(0);

  if (markerDetected) {
    loveGlow = min(loveGlow + glowSpeed, 1.0);
    
    if (frameCount % 30 == 0 && hearts.size() < 15) {
      hearts.add(new Heart());
    }
  } else {
    loveGlow = max(loveGlow - glowSpeed, 0.0);
  }

  if (loveGlow > 0) {
    cam.loadPixels();
    PImage pinkImage = createImage(cam.width, cam.height, RGB);
    pinkImage.loadPixels();
    
    for (int i = 0; i < cam.pixels.length; i++) {
      color c = cam.pixels[i];
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
    
    tint(255, 200 + 55 * loveGlow);
    image(pinkImage, 0, 0);
    noTint();
    
    for (int i = hearts.size()-1; i >= 0; i--) {
      Heart h = hearts.get(i);
      h.update();
      h.display();
      if (h.isOffScreen()) {
        hearts.remove(i);
      }
    }
  } else {
    image(cam, 0, 0);
  }
}

// Funkcja odpowiedzialna za efekty wizualne dla trybu Smutek
// Zmiana tła na melancholiczne odcienie szarości
void applyBlackWhiteEffect() {
 
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  
  pg.image(cam, 0, 0);
  
  if (bwEffect > 0) {
    pg.loadPixels();
    for (int i = 0; i < pg.pixels.length; i++) {
      color c = pg.pixels[i];
      float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
      float r = lerp(red(c), gray, bwEffect);
      float g = lerp(green(c), gray, bwEffect);
      float b = lerp(blue(c), gray, bwEffect);
      pg.pixels[i] = color(r, g, b);
    }
    pg.updatePixels();
  }
  
  pg.endDraw();
  
  image(pg, 0, 0);
}

// Funkcja odpowiedzialna za efekty wizualne dla trybu niepokój
// Nałożenie niespokojnego, pulsującego czerwonego tła
// Dodatkowow wykorzystanie OpenCV do detekcji krawędzi
void applyAnxietyEffect() {
  if (cam.available()) {
    cam.read();
  }

  nya.detect(cam);
  markerDetected = nya.isExist(0); 

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
  
  opencv.loadImage(cam);
  opencv.findCannyEdges(20, 75); 
  edgeImage = opencv.getSnapshot(); 

  if (markerDetected) {
    cam.loadPixels();
    PImage redImage = createImage(cam.width, cam.height, RGB);
    redImage.loadPixels();
    
    for (int i = 0; i < cam.pixels.length; i++) {
      color c = cam.pixels[i];
      float gray = red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114;
      float r = gray + (255 - gray) * pulseIntensity;
      float g = gray * (1.0 - pulseIntensity * 0.9);
      float b = gray * (1.0 - pulseIntensity * 0.9);
      redImage.pixels[i] = color(r, g, b);
    }
    redImage.updatePixels();
    
    pushMatrix();
    translate(width/2, height/2);
    scale(1.0 + pulseIntensity * 0.05);
    translate(-width/2, -height/2);
    image(redImage, 0, 0);
    popMatrix();
    
    if (frameCount % 5 == 0) { 
      fill(255, 0, 0, 30 * pulseIntensity);
      rect(0, 0, width, height);
    }
  } else {
    image(cam, 0, 0);
  }
}


void captureEvent(Capture c) {
  c.read();
}
