import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;
FFT fft;
import java.util.Arrays;

// This is the number of points we want to draw in the line
// Must be a power of 2
int FREQ_BANDS = 8;

void setup() {
    size(800,800);
    
    song = new SoundFile(this, "Drive.mp3");
    song.play();
    
    // Pass song into FFT object
    fft = new FFT(this, FREQ_BANDS);
    fft.input(song);
}

void draw() {   
    background(0);
    stroke(255);
    strokeWeight(1);
    noFill();

    // Get the array of different frequencies
    float[] frequencyArray = fft.analyze();
    // System.out.println(BANDWIDTH);

    drawBarGraph(frequencyArray);
    drawBass();
    drawVectorField();
}

void drawBarGraph(float[] frequencyArray) {
    // width of each rectangle is the width of the window divided by # of samples
    float BANDWIDTH = width/FREQ_BANDS;   

    // start drawing the shape
    beginShape();

    for (int i = 0; i < FREQ_BANDS; i++)
    {
      float amp = frequencyArray[i];
      float y = map(amp, 0, 1, height, 0);
      float x = map(i, 0, FREQ_BANDS, 0, width);
      //width of each sample graphed as a rectangle
      rect(x , y, BANDWIDTH, height);
    }
    // stop drawing the shape
    endShape();
}

void drawBass() {

}

void drawVectorField() {

}

// For a button to pause/unpause song
void toggleSong() {
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.play();
  }
}
