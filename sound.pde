import processing.sound.*;

SinOsc sunOsc, loveOsc, anxietyOsc;
WhiteNoise noise;

void sound_setup() {
  size(800, 600);

  sunOsc = new SinOsc(this);
  loveOsc = new SinOsc(this);
  anxietyOsc = new SinOsc(this);
  noise = new WhiteNoise(this);
}

void playEffectSound(int icon_set, int index) {
  if (icon_set == 1 && index == 1) { 
    sunOsc.freq(220 + random(10, 50));
    sunOsc.amp(0.3);
    sunOsc.play();
    delay(500);
    fadeOut(sunOsc);
  } 
  else if (icon_set == 1 && index == 0) { 
    loveOsc.freq(330);
    loveOsc.amp(0.5);
    loveOsc.play();
    delay(200);
    fadeOut(loveOsc);
  } 
  else if (icon_set == 2 && index == 0) { 
    anxietyOsc.freq(random(100, 200));
    anxietyOsc.amp(0.5);
    anxietyOsc.play();
    delay(200);
    fadeOut(anxietyOsc);
  } 
  else if (icon_set == 2 && index == 1) { 
    noise.amp(0.2);
    noise.play();
    delay(500);
    fadeOut(noise);
  }
}

void fadeOut(SinOsc osc) {
  for (float i = 0.2; i > 0; i -= 0.02) {
    osc.amp(i);
    delay(50);
  }
  osc.stop();
}

void fadeOut(WhiteNoise noise) {
  for (float i = 0.2; i > 0; i -= 0.02) {
    noise.amp(i);
    delay(50);
  }
  noise.stop();
}
