import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile song;
Waveform waveform;
FFT fft;
import java.util.Arrays;
import java.util.stream.*;

VectorField vectorField;

// This is the number of points we want to draw in the line
// Must be a power of 2
int FREQ_BANDS = 8;

// Holds the frequency values
// Size: FREQ_BANDS
float[] FREQ_ARRAY;

// the amount of points in each axis of the vector field
int FIELD_DENSITY = 50;

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
    vectorField.drawPoints();
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
  Point[][] field;

  public VectorField() {
    // allocate memory for the vector field
    this.field = new Point[FIELD_DENSITY][FIELD_DENSITY];
    // initialize each point in the vector field
    this.initPoints();
  }
  
  void initPoints() {
    /* Must be between -1 and 1 */
    float CONSTANT_X = 0;
    float CONSTANT_Y = 0;

    int fieldY = 0;
    for (int y = 0; y < height; y += (height/FIELD_DENSITY)) {
      int fieldX = 0;
      for (int x = 0; x < width; x += (width/FIELD_DENSITY)) {
        int freqBand = this.freqRenderRule(x, y);
        Point point = new Point(x, y, CONSTANT_X, CONSTANT_Y, freqBand);
        this.field[fieldX][fieldY] = point;
        fieldX++;
      }
      fieldY++;
    }
  }

  void drawPoints() {
    // loop through all points
    for (int y = 0; y < FIELD_DENSITY; y++) {
      for (int x = 0; x < FIELD_DENSITY; x++) {
        Point point = this.field[x][y];
        // draws each point
        point.draw();
        point.update();
      }
    }
  }

  /* The rule used to determine which part of the frequency spectrum each point will represent */
  int freqRenderRule(int x, int y) {
    /* Rule 1: Display each frequency across x axis */
    int freqBand = (int) map(x, 0, width, 0, FREQ_BANDS);
    return freqBand;
  }
}

public class Vector {
    /* Normalized vector, may be between -1 and 1 */
    private float vx;
    private float vy;

    public Vector(float vx, float vy)
    {
      this.vx = vx;
      this.vy = vy;
    }

    public float vx() { 
      return this.scale_value(this.vx); 
    }
    public float vy() {
      return this.scale_value(this.vy);
    };

    /* Scale the norm values to the vector field*/ 
    public float scale_value(float val) {
      return map(abs(val), 0, 1, 0, width/FIELD_DENSITY) * (vx >= 0 ? 1 : -1);
    }

    /* Use frequency value to update the vector */
    public void update(float frequency, float deltaFrequency) {
      // Split up the freq between x and y axis

      // TO DO: Use smoothing somehow
      this.vx = frequency * deltaFrequency;
      this.vy = frequency * (1-deltaFrequency);
      return;
    }

    boolean hasAmplitude() {
      return this.vx != 0 && this.vy != 0;
    }
}

public class Point {
  int x;
  int y;
  Vector vector;

  /* Part of frequency spectrum (index in FREQ_ARRAY) this point is visualizing */
  /* 0 <= freqBand < FREQ_BANDS */
  int freqBand;
  float oldFrequency;

  public Point(int x, int y, float vx, float vy, int freqBand)
  {
    this.x = x;
    this.y = y;
    this.vector = new Vector(vx, vy);
    this.freqBand = freqBand;
    this.oldFrequency = 0;
  }

  void printLocation() {
    System.out.println(String.format("Location: (%d, %d), FreqBand: %d ", this.x, this.y, this.freqBand));
  }

  void draw() {
    beginShape();
    point(this.x, this.y);
    line(this.x, this.y, this.x + this.vector.vx(), this.y + this.vector.vy());
    endShape();
  }

  /* Update the point using its own properties */
  void update() {
    float newFrequency = FREQ_ARRAY[this.freqBand];
    float deltaFrequency = (this.oldFrequency - newFrequency) / this.oldFrequency;
    this.vector.update(newFrequency, deltaFrequency);
    this.oldFrequency = newFrequency;
  }
}

// For a button to pause/unpause song
void toggleSong() {
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.play();
  }
}
