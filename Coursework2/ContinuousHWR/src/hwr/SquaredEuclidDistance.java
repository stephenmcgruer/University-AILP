package hwr;

/**
 * SquaredEuclidDistance extends the Distance class
 * to provide Squared Euclidean distance calculations
 * between points.
 */
public class SquaredEuclidDistance extends Distance {

  /**
   * Calculates the distance between two points using
   * the squared euclidean distance metric. Ignores
   * the last point as it is the stroke information.
   *
   * @param a	The first point, in the form [x1,x2,...,stroke_num].
   * @param b	The second point, in the form [x1,x2,...,stroke_num].
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
