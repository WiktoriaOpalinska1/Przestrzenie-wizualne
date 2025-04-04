/*
Technologie kognitywne
Projekt 1
Temat: Przestrzenie wizualne
Grupa: Kędziora Aleksandra, Opalińska Wiktoria, Woźniak Kamil

Działanie projektu:
- Program rozpoznawszy markery, zmienia przestrzeń wizualną użytkownika.
- Program działa w dwóch trybach: stany pozytywne i stany negatywne.
- W zależności od rozpoznanego markera i trybu uruchamiany jest jeden z 4 efektów:
  Miłość, Radość, Niepokój, Smutek.
- Program zmienia tło, efekty dźwiękowe i wyświetlany item stosownie do wyboru użytkownika.
- Projekt ma na celu wpłynięcie na odczucia użytkownika.
*/

import processing.pdf.*;

void setup(){
  size(640, 480,P3D);
  colorMode(RGB, 255);
  frameRate(30);
  bgColor = color(0); 
  GUI_setup();
  music_setup();
  icons_setup();
  visual_setup();
  //sound_setup();
}

void draw() {
  apply_effects();
}
