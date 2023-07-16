import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;
FFT fft;
import java.util.Arrays;

// This is the number of points we want to draw in the line
// Must be a power of 2
int frequencyBands = 256;

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

void draw() {  
    background(0);
    stroke(255);
    strokeWeight(4);
    noFill();
    // Get the array of different frequencies
    float[] frequencyArray = fft.analyze();
    System.out.println(Arrays.toString(frequencyArray));

    // start drawing the line
    beginShape();
    // draw a point for each "sample"
    for (int i = 0; i < frequencyBands; i++)
    {
      float amp = frequencyArray[i];
      float y = map(amp, 0, 1, height, 0);
      float x = map(i, 0, frequencyBands, 0, width);
      line(x, height, x, y);
      
    }
    // stop drawing the line
    endShape();
}
