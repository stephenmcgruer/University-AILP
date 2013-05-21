package hwr;

/**
 * SlantNormalisation extends the Normalisation class,
 * providing a slant-based normalisation.
 */
public class SlantNormalisation extends Normalisation {

  /**
   * Normalises a set of points, attempting to correct
   * character slant using the algorithm given below.
   *
   * @param points    The points to normalise.
   * 
   * @return          The normalised points.
   */
  public float[][] normalise(float[][] input_points) {
   
    // Algorithm:
    // 1. Find the maximum horizontal distance in the input.
    // 2. Rotate the image from -30 to +30 degrees.
    //   2.1. Each time, check if maximum horizontal distance improves.
    //   2.2. If it is, then set the current unslanted image to be the best.
    
    // Slant correction is given by:
    //
    //   x' = x - (y - meanY)tan(slant_angle)
    //   y' = y
    
    float best_points[][] = input_points;
    float bestDiff;

    float sumY;
    float maxX;
    float minX;

    maxX = minX = input_points[0][0];
    sumY = input_points[0][1];

    float meanY;
    
    for(int i = 1; i < input_points.length; i++) {
      if(input_points[i][0] > maxX) maxX = input_points[i][0];
      if(input_points[i][0] < minX) minX = input_points[i][0];
      sumY += input_points[i][1];
    }

    bestDiff = maxX - minX;
    meanY = sumY / input_points.length;
    // degrees: 30 to -30
    for(int i = 30; i >= -30; i -= 5) {

      float[][] temp_points = deepClone(input_points);
      float tempMaxX;
      float tempMinX;
      tempMaxX = tempMinX = temp_points[0][0];

      for(int j = 0; j < temp_points.length; j++) {
        temp_points[j][0] = temp_points[j][0] - (float) ((temp_points[j][1] - meanY)*java.lang.Math.tan(java.lang.Math.toRadians(i)));
        if(temp_points[j][0] > tempMaxX) tempMaxX = temp_points[j][0];
        if(temp_points[j][0] < tempMinX) tempMinX = temp_points[j][0];
      }

      if((tempMaxX - tempMinX) < bestDiff) {
        best_points = deepClone(temp_points);
        bestDiff = tempMaxX - tempMinX;
      }

    }

    return best_points;

  }

  /**
   * A quick and dirty implementation of a deep clone. Assumes
   * that the second level of the array only contains primitives
   * as it just calls .clone() on each element of the first
   * level and so if the second level contains references
   * they will be copied over verbatim to the new array.
   *
   * @param input   The array that is to be cloned.
   * 
   * @return        A cloned copy of the input.
   */
  public float[][] deepClone(float[][] input) {

    int len = input.length;
    float[][] returnArr = new float[len][];

    for(int i = 0; i < len; i++) {
      returnArr[i] = input[i].clone();
    }
    
    return returnArr;

  }

}
