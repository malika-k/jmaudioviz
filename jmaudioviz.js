var song;
var sliderVolume;
var sliderRate;
var sliderPan;
var button;
var fft;
var FREQ_BANDS = 512;
var FREQ_ARRAY = [];
var w;

function setup() {
  createCanvas(FREQ_BANDS*2, FREQ_BANDS*2);
  colorMode(HSB);
  //song will not play untill fully loaded
  song = loadSound("Drive.mp3", loaded);
  //slider params: range, starting point, increment by
  sliderVolume = createSlider(0, 1, 0.03, 0.01);
  sliderRate = createSlider(0, 2, 1, 0.01);
  sliderPan = createSlider(-1, 1, 0, 0.01);
  fft = new p5.FFT();
  //width of each rectangle
  w = width/FREQ_BANDS
  //fft stuff

  //console.log(spectrum.length);

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

  drawBarGraph();
}

function drawBarGraph() {
  
  
  var spectrum = fft.analyze();
  console.log(spectrum);
  stroke(255);
  for (var i = 0; i < spectrum.length; i++) {
    var amp = spectrum[i];
    var y = map(amp, 0, 256, height, 0);
    fill(i, 255, 255)
    rect(i*w, y, w, height-y);
  }
 
}

