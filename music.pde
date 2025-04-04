import processing.sound.*;

SoundFile loveSound, sunshineSound, anxietySound, sadnessSound;

void music_setup() {
  loveSound = new SoundFile(this, "love.mp3");
  sunshineSound = new SoundFile(this, "sunshine.mp3");
  anxietySound = new SoundFile(this, "anxiety.wav");
  sadnessSound = new SoundFile(this, "sadness.mp3");
}

void playEffectMusic(int iconSet, int marker) {
  stopAllSounds(iconSet, marker);
  
  if (iconSet == 1 && marker == 0) {
    if (!loveSound.isPlaying()){
      loveSound.loop();
    }
  } else if (iconSet == 1 && marker == 1) {
    if (!sunshineSound.isPlaying()){
      sunshineSound.loop();
    }
    
  } else if (iconSet == 2 && marker == 0) {
    if (!anxietySound.isPlaying()){
      anxietySound.loop();
    }  
  } else if (iconSet == 2 && marker == 1) {
    if (!sadnessSound.isPlaying()){
      sadnessSound.loop();
    }  
  }
}

void stopAllSounds(int iconSet, int marker) {
   if (iconSet == 1){
    anxietySound.stop();
    sadnessSound.stop();
    if (marker == 0){
       sunshineSound.stop();
    } else if( marker == 1){
      loveSound.stop();
    }
  } else if (iconSet == 2){
    loveSound.stop();
    sunshineSound.stop();
    if (marker == 0){
      sadnessSound.stop();
    } else if( marker == 1) {
      anxietySound.stop();
    }
}

/*
  
  }*/
