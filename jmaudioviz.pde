import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;

// need to lookup what samples actually are. Seems to effect intensity of waveform. 
int samples = 450;

void toggleSong() {
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.play();
  }
}

void setup() {
    size(800,800);
    
    song = new SoundFile(this, "Drive.mp3");
    song.play();
    
    waveform = new Waveform(this, samples);
    waveform.input(song);
}

void draw() {  
    background(0);
    stroke(255);
    strokeWeight(4);
    noFill();
    waveform.analyze();
    
    beginShape();
      for(int i = 0; i < samples; i++)
    {
      vertex(
        map(i, 0, samples, 0, width),
        map(waveform.data[i], -1, 1, 0, height)
      );
    }
    endShape();
   
}
