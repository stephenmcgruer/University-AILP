package hwr;

/**
 * An extension of the Normalisation class representing
 * a translation of the input points to be centered
 * at (0,0).
 */
public class MeanNormalisation extends Normalisation {

  /**
   * Mean normalise a set of input points, using 
   * the following formula.
   *
   *  x' = x - meanX
   *  y' = y - meanY
   *
   * @param points  The set of points to normalise.
   * 
   * @return        The normalised set of points.
   */
  public float[][] normalise(float[][] points) {

    int numPoints = points.length;
    float sumX = 0;
    float sumY = 0;
    float meanX;
    float meanY;

    // Sum the X and Y values.
    for (int i = 0; i < numPoints; ++i) {
      sumX += points[i][0];
      sumY += points[i][1];
    }

    // Calculate the means.
    meanX = sumX / numPoints;
    meanY = sumY / numPoints;

    // Move the points.
    for (int i = 0; i < numPoints; ++i) {
      points[i][0] = points[i][0] - meanX;
      points[i][1] = points[i][1] - meanY;
    }

    return points;

  }

}
