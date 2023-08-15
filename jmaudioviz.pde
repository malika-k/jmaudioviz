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

// the amount of points in each axis of the vector field
int FIELD_DENSITY = 50;

void setup() {
    size(800,800);
    
    song = new SoundFile(this, "Drive.mp3");
    song.play();
    
    // Pass song into FFT object
    fft = new FFT(this, FREQ_BANDS);
    fft.input(song);

    // Set up Vector Field
    vectorField = new VectorField();
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
    // Set all vectors to be (5, 0)
    int CONSTANT_X = 25; // TO DO: SWITCH BACK TO 1 after normalize in draw method
    int CONSTANT_Y = 0;

    int fieldY = 0;
    for (int y = 0; y < height; y += (height/FIELD_DENSITY)) {
      int fieldX = 0;
      for (int x = 0; x < width; x += (width/FIELD_DENSITY)) {
        Point point = new Point(x, y, CONSTANT_X, CONSTANT_Y);
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
      }
    }
  }
}

public class Vector {
    int vx;
    int vy;

    public Vector(int vx, int vy)
    {
      this.vx = vx;
      this.vy = vy;
    }

    public int vx() { return this.vx; }
    public int vy() { return this.vy; };
}

public class Point {
  int x;
  int y;
  Vector vector;

  public Point(int x, int y, int vx, int vy)
  {
    this.x = x;
    this.y = y;
    this.vector = new Vector(vx, vy);
  }

  void printLocation() {
    System.out.println(String.format("(%d, %d)", this.x, this.y));
  }

  void draw() {
    beginShape();
    point(this.x, this.y);

    // TODO: assuming vector is normalized, map vector to fill each square

    line(this.x, this.y, this.x + this.vector.vx, this.y + this.vector.vy);
    endShape();
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
