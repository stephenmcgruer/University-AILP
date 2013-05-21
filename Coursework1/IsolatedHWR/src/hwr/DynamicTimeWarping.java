package hwr;

/* see http://en.wikipedia.org/wiki/Dynamic_time_warping */
public class DynamicTimeWarping extends TimeWarping {

  /** 
   * Set the distance function to use. 
   */
  public DynamicTimeWarping(Distance dist) {
    super(dist);
  }

  /**
   * Calculates the distance between two sets of point, using
   * the DTW algorithm.
   * 
   * @param a   One of the points to compare, in the form of a
   *            2d array of points.
   * @param b   One of the points to compare, in the form of a
   *            2d array of points.
   * 
   * @return    The DTW distance between the two points, calculated
   *            using the DTW algorithm.
   */
  public float calcDistance(float a[][], float b[][]) {

    int ni = a.length;
    int nj = b.length;
    float dtw[][] = new float[ni][nj];

    dtw[0][0] = 0;

    for (int i = 0; i < ni; ++i) {
      for (int j = 0; j < nj; ++j) {
        // Calculate the current 'cost' between the two points.
        float cost = distFun.dist(a[i], b[j]);

        // Return the cheapest cost between 'inserting' a point,
        // 'deleting' a point and a straight match.
        dtw[i][j] = min3(getdtw(dtw, i-1, j) + cost,      // Insertion.
                         getdtw(dtw, i, j-1) + cost,      // Deletion.
                         getdtw(dtw, i-1, j-1) + cost*2); // Match.
      }
    }
    return dtw[ni-1][nj-1]/(ni+nj);
  }

  /**
   * Calculates the minimum of three floats.
   *
   * @param a 
   * @param b
   * @param c
   *
   * @return    The minimum of the three inputs.
   */
  float min3(float a, float b, float c) {
    return Math.min(Math.min(a, b), c);
  }


  /**
   * Helper method for calcDistance - returns the correct
   * value for dtw[i][j] including consideration if
   * i,j negative.
   *
   * @param dtw
   * @param i
   * @param j
   *
   * @return    dtw[i][j] if i, j non-negative, 0 if
   *            i, j negative or 'infinity' if i or
   *            j negative (but not both.)
   *
   */
  float getdtw(float dtw[][], int i, int j) {

    if (i == -1 && j == -1) {
      return 0;
    } else if (i < 0 || j < 0) {
      // Float.MAX_VALUE is used in place of 'infinity'
      // for the DTW algorithm.
      return Float.MAX_VALUE;
    } else {
      return dtw[i][j];
    }

  }

}
