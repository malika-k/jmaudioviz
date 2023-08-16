import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;
FFT fft;
import java.util.Arrays;
import java.util.stream.*;

VectorField vectorField;

// This is the number of vectors we want to draw in the line
// Must be a power of 2
int FREQ_BANDS = 8;

// Holds the frequency values
// Size: FREQ_BANDS
float[] FREQ_ARRAY;

// the amount of vectors in each axis of the vector field
int FIELD_DENSITY = 8;

void setup() {
    size(800,800);
    
    song = new SoundFile(this, "Drive.mp3");
    song.play();
    
    // Pass song into FFT object
    fft = new FFT(this, FREQ_BANDS);
    fft.input(song);

    // Init memory for frequency array
    FREQ_ARRAY = new float[FREQ_BANDS];

    // Set up Vector Field
    vectorField = new VectorField();
}

void draw() {   
    background(0);
    stroke(255);
    strokeWeight(1);
    noFill();

    // Refresh the array of different frequencies
    FREQ_ARRAY = fft.analyze();

    // System.out.println(BANDWIDTH);

    drawBarGraph(FREQ_ARRAY);
    drawBass();
    vectorField.drawVectors();
    vectorField.updateVectors();
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

public class VectorField {
  Vector[][] field;

  public VectorField() {
    // allocate memory for the vector field
    this.field = new Vector[FIELD_DENSITY][FIELD_DENSITY];
    // initialize each vector in the vector field
    this.initVectors();
  }
  
  void initVectors() {
    float defaultAngle = 0f;

    int fieldY = 0;
    for (int y = 0; y < height; y += (height/FIELD_DENSITY)) {
      int fieldX = 0;
      for (int x = 0; x < width; x += (width/FIELD_DENSITY)) {
        int freqBand = 0;
        Vector vector = new Vector(x, y, defaultAngle);
        this.field[fieldX][fieldY] = vector;
        fieldX++;
      }
      fieldY++;
    }
  }

  void drawVectors() {
    // loop through all vectors
    for (int y = 0; y < FIELD_DENSITY; y++) {
      for (int x = 0; x < FIELD_DENSITY; x++) {
        Vector vector = this.field[x][y];
        // draws each vector
        vector.draw();
      }
    }
  }

  void updateVectors() {
    for (int y = 0; y < FIELD_DENSITY; y++) {
      for (int x = 0; x < FIELD_DENSITY; x++) {
        Vector vector = this.field[x][y];
        // updates each vector
        float newAngle = (1.0/100.0) * ((y - this.field.length/2) + (x - this.field[0].length/2)) + 0.001;
        vector.updateAngle(newAngle);
      }
    }
    
  }
}


public class Vector {
  int x;
  int y;
  float angle;

  /* Part of frequency spectrum (index in FREQ_ARRAY) this vector is visualizing */
  /* 0 <= freqBand < FREQ_BANDS */
  int freqBand;

  public Vector(int x, int y, float angle)
  {
    this.x = x;
    this.y = y;
    this.angle = angle;
  }

  void printLocation() {
    System.out.println(String.format("Location: (%d, %d), FreqBand: %d ", this.x, this.y, this.freqBand));
  }

  void draw() {
    beginShape();

    float vectorLength = width/FIELD_DENSITY;

    float startX = this.x - (vectorLength)/2.0 * cos(this.angle);
    float startY = this.y - (vectorLength)/2.0 * sin(this.angle);
    float endX = this.x + (vectorLength)/2.0 * cos(this.angle);
    float endY = this.y + (vectorLength)/2.0 * sin(this.angle);	
    line(startX, startY, endX, endY);
    endShape();
  }

  void updateAngle(float newAngle) {
    // int xIndex = (int) map(this.x, 0, width, 0, FIELD_DENSITY);
    // int yIndex = (int) map(this.y, 0, height, 0, FIELD_DENSITY);

    // int negField = 1 - FIELD_DENSITY;

    // float rule = (1.0/100.0) * negField * (xIndex + yIndex);

    this.angle += newAngle;
  }
}
