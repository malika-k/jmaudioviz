import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;
FFT fft;
import java.util.Arrays;

// This is the number of points we want to draw in the line
// Must be a power of 2
int frequencyBands = 16;

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
    
    // Pass song into FFT object
    fft = new FFT(this, frequencyBands);
    fft.input(song);
}
// width of each rectangle is the width of the window divided by # of samples

//width of each sample graphed as a rectangle

void draw() {
    float bandwidth = width/frequencyBands;      
    background(0);
    stroke(255);
    strokeWeight(1);
    noFill();
    // Get the array of different frequencies
    float[] frequencyArray = fft.analyze();
    System.out.println(bandwidth);

    // start drawing the line
    beginShape();
    // draw a point for each "sample"
    for (int i = 0; i < frequencyBands; i++)
    {
      float amp = frequencyArray[i];
      float y = map(amp, 0, 1, height, 0);
      float x = map(i, 0, frequencyBands, 0, width);
      // rect(x, y, width, height)
      rect(x , y, bandwidth, height);
    }
    // stop drawing the line
    endShape();
}
