package hwr;

/**
 * SquaredEuclidDistance extends the Distance class
 * to provide Squared Euclidean distance calculations
 * for points
 */
public class SquaredEuclidDistance extends Distance {

  /**
   * Calculates the distance between two points using
   * the squared euclidean distance metric. Ignore
   * the last point because it's the stroke information.
   *
   * @param a
   * @param b
   *
   * @return    The squared euclidean distance.
   */
  float dist(float a[], float b[]) {

    assert a.length == b.length;

    float sum = 0;
    for (int i = 0; i < a.length-1; ++i) {
      sum += (a[i]-b[i])*(a[i]-b[i]);
    }

    return sum;
  }

}
