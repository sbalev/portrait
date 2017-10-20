// Adapted from http://learningprocessing.com/examples/chp15/example-15-13-Convolution
float convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float total = 0;
  int offset = matrixsize / 2;

  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {

      // What pixel are we testing
      int xloc = x + i - offset;
      int yloc = y + j - offset;
      int loc = xloc + img.width * yloc;

      // Make sure we haven't walked off the edge of the pixel array
      // It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
      loc = constrain(loc, 0, img.pixels.length-1);

      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      total += brightness(img.pixels[loc]) * matrix[i][j];
    }
  }

  // Make sure brightness is within range
  return constrain(total, 0, 255);
}