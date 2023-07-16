import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;

// This is the number of points we want to draw in the line
int samples = 450;

// For a button to pause/unpause song
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
    
    // Pass song into waveform object
    waveform = new Waveform(this, samples);
    waveform.input(song);
}

void draw() {  
    background(0);
    stroke(255);
    strokeWeight(4);
    noFill();
    waveform.analyze();
    
    // start drawing the line
    beginShape();
    // draw a point for each "sample"
    for (int i = 0; i < samples; i++)
    {
      vertex(
        map(i, 0, samples, 0, width), // maps the x value (i) to fit in the canvas width
        map(waveform.data[i], -1, 1, 0, height) // maps the sound value to fit in the canvas height
      );
    }
    // stop drawing the line
    endShape();
}
