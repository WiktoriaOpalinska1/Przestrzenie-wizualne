import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;

void setup() {
  size(640,480,P3D);
  colorMode(RGB, 255);
  println(MultiMarker.VERSION);
  cam = new Capture(this, 640, 480);
  nya = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro",80);   // id=0
  nya.addARMarker("patt.kanji",80);  // id=1
  nya.addARMarker("happy.patt",80);      // id=2
  nya.addARMarker("anxiety.patt",80);      // id=3
  // nya.addNyIdMarker(0,80);
  // nya.addNyIdMarker(1,80);
  cam.start();
}

void draw() {
  if (!cam.available()) {
    return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);
  
  // Wyświetlamy obiekty statycznie w lewym dolnym rogu
  // Ustalamy stałą pozycję - np. 50 px od lewej i 50 px od dołu
  float baseX = 50;
  float baseY = height - 50;
  
  // Jeśli chcesz, aby obiekty były oddzielone (np. jeden nad drugim),
  // możesz użyć offsetu – tutaj wszystkie rysujemy w tym samym miejscu.
  for (int i = 0; i < 4; i++) {
    if (!nya.isExist(i)) {
      continue;
    }
    pushMatrix();
      // Przesuwamy do lewego dolnego rogu
      translate(baseX, baseY, 0);
      
      // Wybieramy, który kształt rysować w zależności od indeksu markera
      if (i == 0) {
        drawMilosc();
      } else if (i == 1) {
        drawSmutek();
      } else if (i == 2) {
        drawRadosc();
      } else {
        drawNiepokoj();
      }
    popMatrix();
  }
}

void drawMilosc() { // serce
  // Zachowujemy oryginalny kod, który rysuje kształt miłości (serce)
  pushMatrix();
    scale(-1, 1);
    stroke(0, 23, 59);
    fill(255, 0, 0);
    noStroke();
    beginShape();
      vertex(0, -20);
      bezierVertex(-25, -40, -50, 0, 0, 40);
      bezierVertex(60, 0, 25, -40, 0, -20);
    endShape(CLOSE);
  popMatrix();
}

void drawSmutek() { // chmurka
  pushMatrix();
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
    drawKrople();
  popMatrix();
}

void drawKrople(){
  rectMode(CENTER);  // środek prostokąta jako punkt odniesienia
  fill(0, 0, 128);   // granatowy kolor
  noStroke();
  float dropY = 50;  // pozycja w osi Y
  float dropW = 10;  // szerokość kropli
  float dropH = 10;  // wysokość kropli
  pushMatrix(); 
    translate(-25, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  pushMatrix();
    translate(-5, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  pushMatrix();
    translate(15, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  pushMatrix();
    translate(35, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
}

void drawRadosc() { // słońce
  pushMatrix();
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
  popMatrix();
}

void drawNiepokoj() { // bryła z boxów
  pushMatrix();
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
  popMatrix();
}
