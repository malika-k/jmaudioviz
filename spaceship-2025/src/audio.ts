export function setupAudio() {
  const audioContext = new AudioContext();
  const lofiAudio: HTMLMediaElement = document.getElementById("lofi-audio");
  const lofiTrack = audioContext.createMediaElementSource(lofiAudio);
  lofiTrack.connect(audioContext.destination);

  const runButton = document.getElementById("run-button");
  const pauseButton = document.getElementById("pause-button");
  const stopButton = document.getElementById("stop-button");

  runButton.addEventListener("click", () => {
    lofiAudio.play();
  });

  pauseButton.addEventListener("click", () => {
    lofiAudio.pause();
  });

  stopButton.addEventListener("click", () => {
    lofiAudio.pause();
    lofiAudio.currentTime = 0;
  });
  return audioContext;
}
