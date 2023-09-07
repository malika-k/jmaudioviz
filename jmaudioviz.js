var song;
var sliderVolume;
var sliderRate;
var sliderPan;
var button;
var button2;
var fft;
var FREQ_BANDS = 512;
var FREQ_ARRAY = [];
var w;

function setup() {
  createCanvas(800, 800);
  colorMode(HSB);
  //song will not play untill fully loaded
  song = loadSound("Drive.mp3", loaded);
  //slider params: range, starting point, increment by
  createDiv("volume");
  sliderVolume = createSlider(0, 1, 0.03, 0.01);
  createDiv("playback speed");
  sliderRate = createSlider(0, 2, 1, 0.01);
  createDiv("audio panning");
  sliderPan = createSlider(-1, 1, 0, 0.01);
  fft = new p5.FFT();
  bassfft = new p5.FFT();
  //width of each rectangle
  w = width/FREQ_BANDS
}

//callback function. pause button doens't load until the sound does
function loaded() {
  song.play();
  button = createButton("Pause");
  button.mousePressed(togglePlaying);
  
  button2 = createButton("Reset");
  button2.mousePressed(toggleReset);
}

function draw() {
  background(0);
  song.setVolume(sliderVolume.value());
  song.rate(sliderRate.value());
  song.pan(sliderPan.value());
  
  drawBarGraph();
  //---------------BASS MESSES WITH COLORMODE.  DONT KNOW WHY YET----------------------
  //-----------------
  drawBass();
  //-----------------
  //-----------------------------------
}

// play|pause 
function togglePlaying() {
  if (song.isPlaying()) {
    song.pause();
    button.html("Resume");
  }
  else {
    song.play();
    button.html("Pause");
  }
  
}

//reset song 
function toggleReset() {
  song.stop();
  song.play();
}

//'bar graph' visualization
function drawBarGraph() {
  
  beginShape();
  
  var spectrum = fft.analyze();
  //console.log(spectrum);
  stroke(255);
  //start loop at 11 because 0-10 are bass frequencies visualized by circles
  for (var i = 11; i < spectrum.length; i++) {
    
    var amp = spectrum[i];
    var y = map(amp, 0, 256, height, 0);
    fill(i, 255, 255);
    rect(i*w, y, w, height-y);
  }
  endShape();
}

//circular visualization of bass frequencies
function drawBass() {
  var x = 0
  beginShape();
  strokeWeight(4);
  
  var spectrum = bassfft.analyze();
  
  for (var i = 0; i < 10; i++) {
    var amp = spectrum[i];
    console.log(amp);
    amp = map(amp, 100, 200, 50, 100);
    circle(400, 600 - x, amp);
    x += 50;
    var g = map(i, 10, 1, 255, 0);
    fill(g, 255, 255);
  }
  endShape();
}

