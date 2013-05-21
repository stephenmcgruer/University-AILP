package hwr;

/**
 * An extension of the Distance class, implementing
 * the Manhattan (city-block) measure of distance.
 *
 * See http://en.wikipedia.org/wiki/Taxicab_geometry
 */
public class ManhattanDistance extends Distance {

  /**
   * Calculates the distance between two points using the Manhattan
   * distance.
   *
   * d(x,y) = sum from n to i of |x[i] - y[i]|
   *
   * @param a
   * @param b
   *
   * @return    The distance between the two input points.
   */
  float dist(float a[], float b[]) {

    // Manhattan distance only works if the input
    // vectors are of equal length.
    assert a.length == b.length;

    float sum = 0;

    // Since a.length == b.length we can use either to count.
    int len = a.length;

    // Ignore the last point as it will be the stroke value.
    for (int i = 0; i < len-1; ++i) {
      sum += java.lang.Math.abs(a[i]-b[i]);
    }

    return sum;

  }

}
