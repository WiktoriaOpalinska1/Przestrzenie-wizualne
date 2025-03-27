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
  nya.addARMarker("h.patt",80);   // id=2
  nya.addARMarker("a.patt",80);  // id=3
 // nya.addNyIdMarker(0,80);                      // id=2
  //nya.addNyIdMarker(1,80);                      // id=3
  cam.start();
}

void draw() {
  if (cam.available() != true) {
    return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam); 

// wyswietlanie obrazkow na znacznikach
  for (int i = 0; i < 4; i++) {
    if (!nya.isExist(i)) {
      continue;
    }
    nya.beginTransform(i);
    
    if (i == 0) {
     drawMilosc();
  } else if (i == 1) {
     drawSmutek();
    } else
    if (i == 2) {
     drawRadosc();
    } else {
     drawNiepokoj();
    }
    
    nya.endTransform();
}
}

void drawMilosc() { //serce
    scale(1, -1);
    fill(255, 0, 0);
    noStroke();
    beginShape();
      vertex(0, -20);
      bezierVertex(-25, -40, -50, 0, 0, 40);
      bezierVertex(60, 0, 25, -40, 0, -20);
    endShape(CLOSE);
}


void drawSmutek() { //chmurka
   stroke(63, 67, 69);
  fill(54, 55, 56);     
  sphereDetail(16);

  // Główna (największa) sfera
  pushMatrix();
    sphere(40);
  popMatrix();

  // Kilka mniejszych sfer, przesuniętych względem głównej
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

}

void  drawKrople(){
     rectMode(CENTER);         // punkt odniesienia - srodek prostokata
  fill(0, 0, 128);          
  noStroke();
  
  // pozycje kropelek
  float dropY = 50;         // pozycja w osi Y 
  float dropW = 10;         // szerokosc kropli
  float dropH = 10;         // wysokosc kropli
  
  // Kropelka 1 – lewa
  pushMatrix();
    translate(-25, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  
  // Kropelka 2 – środkowa
  pushMatrix();
    translate(-5, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  
  // Kropelka 3 – prawa
  pushMatrix();
    translate(15, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
  
  //kropelka 4 - pp
   pushMatrix(); 
    translate(35, dropY, 0);
    rect(0, 0, dropW, dropH);
  popMatrix();
}


void drawRadosc() { //słońce
  fill(255, 204, 0); 
    noStroke();
    sphereDetail(24);  
    sphere(25);        
  
    //promienie
    int numRays = 12;  // liczba promieni
    for (int i = 0; i < numRays; i++) {
      pushMatrix();
        // obrot promieni
        rotateZ(TWO_PI * i / numRays);
        
        // przesuwamy promienie
        translate(30, 0, 0);
        
        fill(247, 247, 161);
        
        // promienei jako box
        box(8, 40, 8);
      popMatrix();
    }
}

void drawNiepokoj() {
  stroke(0, 23, 59);
  
  // glowny box
  fill(2, 62, 158);
  box(60);
  

  
  // Box doł
  pushMatrix();
    translate(0, -20, 0);
    rotateX(PI/4);
    fill(0, 68, 255);
    box(50);
  popMatrix();
  
  // Box 2 lewo gora
  pushMatrix();
    translate(20, 20, 0);
    rotateY(PI/3);
    fill(0, 68, 255);
    box(40);
  popMatrix();
  
  // Box 3: prawo gora
  pushMatrix();
    translate(-20, 20, 0);
    rotateZ(PI/6);
    fill(0, 68, 255);
    box(40);
  popMatrix();
  
 // Box 4: 
  pushMatrix();
    translate(0, 0, 20);
    rotateX(PI/6);
    fill(0, 68, 255);
    box(40);
  popMatrix();
  

}
  
