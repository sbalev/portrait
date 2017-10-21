import processing.video.*;
import java.util.*;

// simple edge detection kernel
float[][] edgeKernel = {
  { -1, -1, -1 }, 
  { -1,  8, -1 }, 
  { -1, -1, -1 }
};

// Smaller valures give more details but make the CPU suffer
// This parameter is controlled by mouse's x position
float edgeThreshold;

// Only connect points below this distance to avoid long ugly lines
final float DISTANCE_THRESHOLD = 30;

List<PVector> points = new ArrayList();

Capture video;

void setup() {
  size(800, 600);
  frameRate(30);
  //printArray(Capture.list());
  video = new Capture(this, 320, 240); 
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(255);
  edgeThreshold = map(mouseX, 0, width, 224, 32);
  collectPoints();
  connectPoints();
}

void collectPoints() {
  points.clear();
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      // is (x, y) edge pixel ?
      float brightness = convolution(x, y, edgeKernel, 3, video);
      if (brightness > edgeThreshold) {
        float sx = map(x, 0, video.width, width, 0); // x is mirrored
        float sy = map(y, 0, video.height, 0, height);
        PVector pv = new PVector(sx, sy);
        points.add(pv);
      }
    }
  }
}

// A simple, "travelling salesman"-like heuristics to connect the points
void connectPoints() {
  for (int i = 0; i < points.size() - 1; i++) {
    PVector pi = points.get(i);
    float minDist = Float.POSITIVE_INFINITY;
    int jMin = -1;
    for (int j = i + 1; j < points.size(); j++) {
      float d = pi.dist(points.get(j));
      if (d < minDist) {
        minDist = d;
        jMin = j;
      }
    }
    if (jMin != i + 1) {
      PVector tmp = points.get(i + 1);
      points.set(i + 1, points.get(jMin));
      points.set(jMin, tmp);
    }
    if (minDist < DISTANCE_THRESHOLD) {
      line(pi.x, pi.y, points.get(i + 1).x, points.get(i + 1).y);
    }
  }
}

// click to take a screenshot
void mousePressed() {
  saveFrame("frame####.png");
}