package hwr;

/**
 * An extension of the Normalisation class representing
 * a smoothing of the input points.
 */
public class SmoothNormalisation extends Normalisation {

  /**
   * Smooth a set of input points.
   * 
   * @param points  The array of points to smooth.
   * @return        The smoothed points.
   */
   
  public float[][] normalise(float[][] points) {

    // Based on method from Garsen paper. Ratio determined by experimentation.
    for(int i = 2; i < points.length-2; i++) {

      // Check that all of our points are in the same stroke.
      // If not, move to the next loop until they are.
      // Can use "==" because all ints would be mis-converted
      // to the same value of float if mis-converted.
      if (!(points[i][2] == points[i-1][2]))
        continue;

      points[i][0] = (1.0f/4.0f) * points[i-1][0] + (3.0f/4.0f) * points[i][0]; 
      points[i][1] = (1.0f/4.0f) * points[i-1][1] + (3.0f/4.0f) * points[i][1];

    }
    
    // Based on method from stackexchange:
    // http://math.stackexchange.com/questions/6057/how-do-i-apply-a-gaussian-blur-low-pass-filter-to-an-image-made-up-from-a-set-o
    /*
    for (int i = 2; i < points.length-2; i++) {

      // Check that all of our points are in the same stroke.
      // If not, move to the next loop until they are.
      // Can use "==" because all ints would be mis-converted
      // to the same value of float if mis-converted.
      if (!(points[i][2] == points[i-2][2] &&
            points[i][2] == points[i-1][2] &&
            points[i][2] == points[i+1][2] &&
            points[i][2] == points[i+2][2])) 
        continue;


      points[i][0] = 0.01330373f*points[i-2][0]
                   + 0.11098164f*points[i-1][0] + 0.22508352f*points[i][0]
                   + 0.11098164f*points[i+1][0] + 0.01330373f*points[i+2][0];
      points[i][1] = 0.01330373f*points[i-2][1] 
                   + 0.11098164f*points[i-1][1] + 0.22508352f*points[i][1] 
                   + 0.11098164f*points[i+1][1] + 0.01330373f*points[i+2][1];
    }
    */
    
    // Based on gaussian method.
    /*
    for (int i = 2; i < points.length -2; i++) {

      // Check that all of our points are in the same stroke.
      // If not, move to the next loop until they are.
      // Can use "==" because all ints would be mis-converted
      // to the same value of float if mis-converted.
      
      if (!(points[i][2] == points[i-2][2] &&
            points[i][2] == points[i-1][2] &&
            points[i][2] == points[i+1][2] &&
            points[i][2] == points[i+2][2])) 
        continue;


      points[i][0] = (0.5f/5.0f)*points[i-2][0]
                   + (1.0f/5.0f)*points[i-1][0] + (2.0f/5.0f)*points[i][0]
                   + (1.0f/5.0f)*points[i+1][0] + (0.5f/5.0f)*points[i+2][0];
      points[i][1] = (0.5f/5.0f)*points[i-2][1] 
                   + (1.0f/5.0f)*points[i-1][1] + (2.0f/5.0f)*points[i][1] 
                   + (1.0f/5.0f)*points[i+1][1] + (0.5f/5.0f)*points[i+2][1];
    }
    */

    return points;

  }

}
