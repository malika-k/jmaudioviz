import "./style.css";
//import { setupAudio } from "./audio.ts";
import * as THREE from "three";

//setupAudio();

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(
  50,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);

const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

// spawn multiple boxes randomly near the center cube
function spawnBoxes(numBoxes: number) {
  const boxes = [];
  for (let i = 0; i < numBoxes; i++) {
    const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5);
    const material = new THREE.MeshBasicMaterial({ color: 0xcf2404 });
    const box = new THREE.Mesh(geometry, material);
    // reject boxes that are too close to the center cube
    let x, y, z;
    do {
      x = (Math.random() - 0.5) * 4;
      y = (Math.random() - 0.5) * 4;
      z = (Math.random() - 0.5) * 4;
    } while (Math.sqrt(x * x + y * y + z * z) < 1.0);
    box.position.set(x, y, z);
    scene.add(box);
    boxes.push(box);
  }
  return boxes;
}
function spawnPyramid() {
  const geometry = new THREE.ConeGeometry(1, 2, 4);
  // (radius, height, radialSegments=4)
  const material = new THREE.MeshBasicMaterial({
    color: 0xffaa00,
    wireframe: false,
  });
  const pyramid = new THREE.Mesh(geometry, material);
  pyramid.position.set(0, -5, 0);
  scene.add(pyramid);
}

//spawn center cube
const geometry = new THREE.BoxGeometry(0.5, 0.5, 0.5);
const material = new THREE.MeshBasicMaterial({ color: 0x9f04cf });
const cube = new THREE.Mesh(geometry, material);
//scene.add without a postion will place it at 0,0,0
scene.add(cube);

//-------------------
//Function that spawns multiple boxes randomly near the center cube
// '10' can change to user input later
const extraBoxes = spawnBoxes(5);
camera.position.z = 5;

//-------------------
//spawn pyramid
const pyramid = spawnPyramid();

//-------------------
//animate function
function animate() {
  requestAnimationFrame(animate);

  cube.rotation.x += 0.005;
  cube.rotation.y += 0.005;

  extraBoxes.forEach((box) => {
    box.rotation.x += 0.01;
    box.rotation.y += 0.01;
  });

  renderer.render(scene, camera);
}

animate();
