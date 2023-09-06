var song;
var sliderVolume;
var sliderRate;
var sliderPan;
var button;
var amp;
var currentVolume;

function setup() {
  createCanvas(600, 600);
  //song will not play untill fully loaded
  song = loadSound("Drive.mp3", loaded);
  amp = new p5.Amplitude();
  //slider params: range, starting point, increment by
  sliderVolume = createSlider(0, 1, 0.03, 0.01);
  sliderRate = createSlider(0, 2, 1, 0.01);
  sliderPan = createSlider(-1, 1, 0, 0.01);

  //var for volume mapping 
  currentVolume = sliderVolume.value();
  
  //fft = new FFT(this, FREQ_BANDS);
  //fft.input(song);  
  //FREQ_ARRAY = new float[FREQ_BANDS];
}

//function for play/pause button
function togglePlaying() {
  if (song.isPlaying()) {
    song.pause();
    button.html("Play");
  }
  else {
    song.play();
    button.html("Pause");
  }
}

//callback function. pause button doens't load until the sound does
function loaded() {
  song.play();
  button = createButton("Pause");
  button.mousePressed(togglePlaying);
}

function draw() {
  background(0);
  song.pan(sliderPan.value());
  song.setVolume(sliderVolume.value());
  song.rate(sliderRate.value());
}

