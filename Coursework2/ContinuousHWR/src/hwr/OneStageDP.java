package hwr;

import java.lang.Math;
import java.util.ArrayList;
import java.util.Collections;

/**
 * OneStageDP provides recognition of an input sequence through use
 * of the One Stage Dynamic Programming algorithm described by 
 * Ney in his 1984 paper.
 */
public class OneStageDP {

  // Distance type to use when calculating distance between points.
  private Distance distFunc;

  public OneStageDP(Distance distFunc) {
    this.distFunc = distFunc;
  }

  // Default distance type is euclidean distance.
  public OneStageDP() {
    this.distFunc = new SquaredEuclidDistance();
  }

  /**
   * Classifies an input pattern as a sequence of reference patterns,
   * using the One Stage DP algorithm. 
   *
   * @param input_pats The input pattern to recognise.
   * @param ref_pats   An array of reference pattern templates.
   *
   * @return           An array of indices which represent the
   *                   recognised symbol sequence.
   */
  public int[] recognise(float[][] input_pats, float[][][] ref_pats) {
    
    float D[][][] = new float[input_pats.length][ref_pats.length][];

    // Create the sub-arrays.
    for (int i = 0; i < D.length; i++) {
      for (int k = 0; k < D[i].length; k++) {
        D[i][k] = new float[ref_pats[k].length];
      }
    }

    // Step 1 - initialise the leftmost column.
    for (int k = 0; k < ref_pats.length; k++) {
      for (int j = 0; j < ref_pats[k].length; j++) {
        float sum = 0;
        for (int jstar = 0; jstar < j; jstar++) {
          sum += D[0][k][jstar];
        }
        D[0][k][j] = distFunc.dist(input_pats[0], ref_pats[k][j]) + sum;
      }
    }

    // Step 2 - build the rest of the table.
    for (int i = 1; i < D.length; i++) {
      for (int k = 0; k < D[i].length; k++) {

        float smallestDist = D[i-1][k][0];

        for (int kstar = 0; kstar < D[i].length; kstar++) {
          int lastIndex = D[i-1][kstar].length - 1;
          smallestDist = Math.min(smallestDist, D[i-1][kstar][lastIndex] + 300);
        } 

        D[i][k][0] = distFunc.dist(input_pats[i], ref_pats[k][0]) + smallestDist;

        for (int j = 1; j < D[i][k].length; j++) {

          float distance =  distFunc.dist(input_pats[i], ref_pats[k][j]);
          D[i][k][j] = minThree(distance + D[i-1][k][j], // Left
                                1.25f * distance + D[i-1][k][j-1], // Down-left
                                2 * distance + D[i][k][j-1]); // Down

        }

      }
    }

    // Step 3 - find the recognition patterns using the table.
    
    ArrayList<Integer> recognisedTemplates = new ArrayList<Integer>();

    int i = D.length-1;

    while (i > 0) {

      // Scan for smallest distance.
      int nextTemplate = 0;
      int lastIndex = D[i][0].length - 1;
      float smallestDist = D[i][0][lastIndex];

      for (int k = 1; k < D[i].length; k++) {
        lastIndex = D[i][k].length - 1;
        if (D[i][k][lastIndex] < smallestDist) {
          smallestDist = D[i][k][lastIndex];
          nextTemplate = k;
        }
      }

      // Now follow the path down till j = 1
      int j = D[i][nextTemplate].length - 1;

      while (j > 0) {

        // If we're at the far left column, just finish.
        if (i == 0) {
          break;
        }

        // Otherwise, follow the path!
        
        float left = D[i-1][nextTemplate][j];
        float down = D[i][nextTemplate][j-1];
        float downLeft = D[i-1][nextTemplate][j-1];

        if (left < down) {
          // Go left.
          i--;
          if (downLeft < left) {
            // Go down too.
            j--;
          } 
        } else {
          // Go down.
          j--;
          if (downLeft < down) {
            // Go left too.
            i--;
          } 
        }

      }

      // Now record the template and start over at the next i value down.
      recognisedTemplates.add(nextTemplate);
      i--;

    }

    // This method of finding the characters starts from the end of the input
    // string - so we need to reverse them.
    Collections.reverse(recognisedTemplates);

    return toIntArr(recognisedTemplates);

  }

  /**
   * Finds the minimum of three floats.
   *
   * @param a   The first float to compare.
   * @param b   The second float to compare.
   * @param c   The third float to compare.
   *
   * @return  The minimum value of the three floats.
   */
  private static float minThree(float a, float b, float c) {
    return Math.min(a, Math.min(b, c));
  }

  /**
   * Converts an ArrayList of Integers to an array of ints. 
   * Necessary as one cannot just directly case the result
   * of inList.toArray() to int[] =[.
   *
   * @param inList    The arraylist to convert.
   *
   * @return          The input arraylist converted to an array
   *                  of primitive ints.
   */
  private static int[] toIntArr(ArrayList<Integer> inList) {
    int[] retArr = new int[inList.size()];
    for (int i = 0; i < inList.size(); i++) {
      retArr[i] = inList.get(i);
    }
    return retArr;
  }

}
