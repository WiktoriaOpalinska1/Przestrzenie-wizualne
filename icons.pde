/*
  Osoba odpowiedzialna: Aleksandra
  
  Co znajduje się w tym pliku:
  - inicjalizacja kamery
  - inicjalizacja znaczników
  - 4 funkcje odpowiedzialne za rysowanie obieków 3D na znacznikach
  
  Wykorzystane biblioteki:
  - Video - obsługa kamery
  - NyARToolkit - obsługa znaczników
*/

void icons_setup() {
  
  println(MultiMarker.VERSION);
  cam = new Capture(this, 640, 480);
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro",80);   // id=0
  nya.addARMarker("patt.kanji",80);  // id=1
  nya.addARMarker("h.patt",80);   // id=2
  nya.addARMarker("a.patt",80);  // id=3
  cam.start();
}

// Funkcja odpowiedzialna za item do trybu miłość - kształt serca
void drawMilosc() {
    scale(1, -1);
    fill(255, 0, 0);
    noStroke();
    beginShape();
      vertex(0, -20);
      bezierVertex(-25, -40, -50, 0, 0, 40);
      bezierVertex(60, 0, 25, -40, 0, -20);
    endShape(CLOSE);
}

// Funkcja odpowiedzialna za item do trybu smutek - kształt chmury z nałożonych sfer
void drawSmutek() { 
   stroke(63, 67, 69);
  fill(54, 55, 56);     
  sphereDetail(16);

  pushMatrix();
    sphere(40);
  popMatrix();

  pushMatrix();
    translate(-25, 0, 10);
    sphere(30);
  popMatrix();
  
  pushMatrix();
    translate(25, 0, -10);
    sphere(30);
  popMatrix();
  
  pushMatrix();
    translate(10, -15, 0);
    sphere(20);
  popMatrix();

  pushMatrix();
    translate(-10, -15, 0);
    sphere(20);
  popMatrix();
}

// Funkcja odpowiedzialna za item do trybu radość - kształt słońca
void drawRadosc() { 
  fill(255, 204, 0); 
    noStroke();
    sphereDetail(24);  
    sphere(25);        
  
    int numRays = 12; 
    for (int i = 0; i < numRays; i++) {
      pushMatrix();
        rotateZ(TWO_PI * i / numRays);
        translate(30, 0, 0);
        fill(247, 247, 161);
        box(8, 40, 8);
      popMatrix();
    }
}

// Funkcja odpowiedzialna za item do trybu niepokój - chaotyczny kształ z 4 boxów
void drawNiepokoj() {
  stroke(0, 23, 59);
  
  fill(2, 62, 158);
  box(60);
  
  pushMatrix();
    translate(0, -20, 0);
    rotateX(PI/4);
    fill(0, 68, 255);
    box(50);
  popMatrix();
  
  pushMatrix();
    translate(20, 20, 0);
    rotateY(PI/3);
    fill(0, 68, 255);
    box(40);
  popMatrix();
  
  pushMatrix();
    translate(-20, 20, 0);
    rotateZ(PI/6);
    fill(0, 68, 255);
    box(40);
  popMatrix();
  
  pushMatrix();
    translate(0, 0, 20);
    rotateX(PI/6);
    fill(0, 68, 255);
    box(40);
  popMatrix();
}
