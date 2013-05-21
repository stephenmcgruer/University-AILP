package hwr;

/**
 * ScaleNormalisation extends the Normalisation class,
 * providing a scale-based normalisation.
 */
public class ScaleNormalisation extends Normalisation {

  /**
   * The basic version of normalise merely calls the
   * more complex version with a default bounding box
   * size of 150.
   *
   * @param points    The points to normalise.
   * 
   * @return          The normalised points, with a 150 pixel
   *                  bounding box.
   */                  
  public float[][] normalise(float[][] points) {
    return normalise(points, 150);
  }

  /**
   * Normalises a set of points in a bounding box
   * of boxSize pixels on each side.
   *
   * @param points    The points to normalise.
   * @param boxSize   The size of the bounding box.
   * @return          The normalised points.
   */
  public float[][] normalise(float[][] points, int boxSize) {

    assert points.length > 0;

    float maxX;
    float minX;
    float maxY;
    float minY;
    float diffX;
    float diffY;
    float multiple;

    maxX = points[0][0];
    minX = points[0][0];
    maxY = points[0][1];
    minY = points[0][1];

    // Get the maximum and minimum x and y values.
    for(int i = 1; i < points.length; ++i) {

      if(points[i][0] > maxX) maxX = points[i][0];
      if(points[i][0] < minX) minX = points[i][0];
      if(points[i][1] > maxY) maxY = points[i][1];
      if(points[i][1] < minY) minY = points[i][1];

    }

    // The larger diff should be the one that we normalise the scale to.
    diffX = maxX - minX;
    diffY = maxY - minY;

    multiple = boxSize / java.lang.Math.max(diffX, diffY);

    // Scale the point values.
    for(int i = 0; i < points.length; ++i) {
      points[i][0] *= multiple;
      points[i][1] *= multiple;
    }

    return points;

  }

}
