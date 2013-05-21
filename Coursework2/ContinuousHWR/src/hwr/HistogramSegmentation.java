package hwr;

import java.lang.Math;
import java.util.ArrayList;
import java.lang.Float;
import java.lang.UnsupportedOperationException;
import java.util.Comparator;
import java.util.Collections;

/**
 * HistogramSegmentation extends the Segmentation class to 
 * provide segmentation of a sequence based on a histogram
 * created for it.
 */
public class HistogramSegmentation extends Segmentation {

  /**
   * Segments an input word by creating a histogram of the
   * points in the word and finding the boundary regions.
   * Performs hard segmentation - i.e. assumes all of the
   * boundaries are definite choices. Returns an array of
   * characters (that is, an array of arrays of points, where
   * a point is a 3-tuple of x, y and stroke.)
   * 
   * Assumes that the input is correctly formed.
   *
   * @param inArr   The input word - an array of points, with
   *                stroke information.
   */
  public float[][][] hardSegment(float[][] inArr) throws UnsupportedOperationException {

    // Find the max and min x point of the word - these are the outer-edge boundaries.
    int maxX = (int) inArr[0][0];
    int minX = (int) inArr[0][0];

    for (int i = 1; i < inArr.length; i++) {
      maxX = Math.max(maxX, (int) inArr[i][0]);
      minX = Math.min(minX, (int) inArr[i][0]);
    }

    // Create the histogram by taking each vector and iterating
    // along it, adding to the histogram as we go.
    int histogram[] = createHistogram(inArr, maxX, minX);

    // We now scan the histogram, looking for boundary regions between the characters.
    ArrayList<Integer> boundaries = new ArrayList<Integer>();

    // Variables to keep track of the start of a boundary, the end
    // of a boundary, and the middle point.
    int startX = 0;
    int endX = 0;
    int midX = 0;

    // The leftmost point (minus 1)  is the first boundary.
    boundaries.add(minX-1);

    // To find the boundary points we search for the start of a boundary
    // (a '0' value), then iterate until we find the end of that boundary.
    // The middle point is calculated and stored.
    for (int i = 0; i < histogram.length; i++) {

      if (histogram[i] != 0) continue;

      startX = i + minX;

      while (i < histogram.length && histogram[i] == 0) i++;

      // If we've reached the end, we're done - the current 'boundary' is
      // just a trailing blank space.
      if (i == histogram.length) break;

      endX = i + minX - 1;

      // Add the middle point of the empty space to the list of boundaries.
      midX = startX + ((endX - startX) / 2);
      boundaries.add(midX);

    }
    // The rightmost point (plus 1)  is the last boundary.
    boundaries.add(maxX + 1);

    // Finally, loop through the original values and place them into the output array
    // based on the character values found above.

    return splitArrByBoundaries(boundaries, inArr);

  }

  /**
   * Segments an input word by creating a histogram of the
   * points in the word and finding the boundary regions.
   * Performs soft segmentation - i.e. attempts to identify the
   * best boundaries to use when segmenting. Returns an array of
   * characters (that is, an array of arrays of points, where
   * a point is a 3-tuple of x, y and stroke.)
   * 
   * Assumes that the input is correctly formed.
   *
   * @param inArr   The input word - an array of points, with
   *                stroke information.
   */
  public float[][][] softSegment(float[][] inArr, float[][][] refArr) throws UnsupportedOperationException {

    // Commands that will be sent to DTW.
    String commands[] = {"mean"};

    // Find the max and minimum X value in the input array.
    int maxX;
    int minX;
    maxX = minX = (int) inArr[0][0];

    for (int i = 1; i < inArr.length; i++) {
      minX = Math.min(minX, (int) inArr[i][0]);
      maxX = Math.max(maxX, (int) inArr[i][0]);
    }

    // Create the histogram by taking each vector and iterating
    // along it, adding to the histogram as we go.
    int histogram[] = createHistogram(inArr, maxX, minX);

    // Next we scan the histogram, looking for characters spaces.
    // The int[] array stores the boundary value and score.
    ArrayList<int[]> possibleBoundaries = new ArrayList<int[]>();

    // Variables to keep track of the start of a boundary, the end
    // of a boundary, the middle point and the width of the boundary.
    int startX = 0;
    int endX = 0;
    int midX = 0;
    int score = 0;

    // To find the boundary points we search for the start of a boundary
    // (a '0' value), then iterate until we find the end of that boundary.
    // The middle point is calculated and stored along with the score (width).
    for (int i = 0; i < histogram.length; i++) {

      if (histogram[i] != 0) continue;

      startX = i + minX;
      while (i < histogram.length && histogram[i] == 0) i++;

      // If we've reached the end, we're done - the current 'boundary' is
      // just a trailing blank space.
      if (i == histogram.length) break;

      // Otherwise, calculate the middle point of the boundary region
      // and store it along with the score.
      endX = i + minX - 1;
      midX = startX + ((endX - startX) / 2);
      score = endX - startX;

      int tmp[] = { midX, score };
      possibleBoundaries.add(tmp.clone());

    }


    // We now must find out which of these boundaries we wish to keep.

    ArrayList<Integer> actualBoundaries = new ArrayList<Integer>();

    // The first and last boundaries will *always* be the beginning and end
    // of the word.
    actualBoundaries.add(minX - 1);
    actualBoundaries.add(maxX + 1);

    // We sort the list of possible boundaries by their score, to find
    // those with a highest width (and thus a more probably boundary) first.
    Collections.sort(possibleBoundaries, COMPARE_BY_SECOND);

    // Distance tracking variables.
    float oldDist = 0;
    float newDist = 0;

    // The initial distance is calculated by just trying to recognize
    // the whole word.
    float tmpArr[][][] = {cloneFloatArr(inArr)};
    oldDist = getTotalDist(tmpArr, refArr, commands);

    // We now iteratively add in the boundaries that we wish to keep,
    // stopping when the total distance from DTWDist goes up.
    while(possibleBoundaries.size() > 0) {

      // Grab the next possible boundary, and add it to the list of
      // final boundaries.
      int nextBoundary[] = possibleBoundaries.remove(0);
      actualBoundaries.add(nextBoundary[0]);
      Collections.sort(actualBoundaries);

      // Check how far the distance is to the input if we split it using
      // our new boundary as well - if it's further away then we discard the
      // latest addition and we're done!

      tmpArr = splitArrByBoundaries(actualBoundaries, inArr);

      newDist = getTotalDist(tmpArr, refArr, commands);

      if (newDist > oldDist) {
        actualBoundaries.remove(actualBoundaries.indexOf(nextBoundary[0]));
        break;
      }

      oldDist = newDist;

    }

    return splitArrByBoundaries(actualBoundaries, inArr);

  }

  /**
   * Creates a histogram for an input array.
   * 
   * The max and min value of x in the array are passed
   * for ease of use (and because they are used elsewhere.)
   * 
   * @param inArr	The array to create the histogram for.
   * @param maxX	The maximum value of x in the input array.
   * @param minX	The minimum value of x in the input array.
   */
  private int[] createHistogram(float[][] inArr, int maxX, int minX) {

    int diffX = maxX - minX;

    int histogram[] = new int[diffX+1];
    for (int i = 0; i < histogram.length; i++) histogram[i] = 0;

    //Fill the histogram!
    for (int i = 0; i < inArr.length-1; i++) {

      // Different strokes (for different folks!) so move on.
      if (inArr[i][2] != inArr[i+1][2]) continue;  

      // Take the leftmost point and traverse towards the right
      // one, adding 1 to the histogram every integer step.
      if (inArr[i][0] < inArr[i+1][0]) {
        for (int j = (int) inArr[i][0]; j <= (int) inArr[i+1][0]; j++) {
          histogram[j-minX]++;
        }
      } else {
        for (int j = (int) inArr[i+1][0]; j <= (int) inArr[i][0]; j++) {
          histogram[j-minX]++;
        }
      }

    }

    return histogram;

  }

  /**
   * Splits a 2D float array into three dimensions using a list of boundaries
   * given to it.
   *
   * @param boundaries      An arraylist of the x-values to split over.
   * @param inArr           The float array to split.
   *
   * @return                A 3D float array consisting of the input split
   *                        into the regions defined by the boundaries variable.
   */
  private float[][][] splitArrByBoundaries(ArrayList<Integer> boundaries, float[][] inArr) {

    // Bloody generics...
    @SuppressWarnings("unchecked")
    ArrayList<float[]>[] splitArr = (ArrayList<float[]>[]) new ArrayList[boundaries.size() - 1];

    for (int i = 0; i < splitArr.length; i++) splitArr[i] = new ArrayList<float[]>();

    // Put each point in the correct ArrayList.
    for (int i = 0; i < inArr.length; i++) {
      for (int j = 0; j < boundaries.size()-1; j++) {
        if ( (int) inArr[i][0] > boundaries.get(j) && (int) inArr[i][0] < boundaries.get(j+1) ) {
          splitArr[j].add(inArr[i].clone());
          break;
        }
      }
    }

    // Convert ArrayList to array...
    float[][][] outArr = new float[splitArr.length][][];
    for (int i = 0; i < splitArr.length; i++) {

      float tmpArr[][] = new float[splitArr[i].size()][];
      for (int j = 0; j < splitArr[i].size(); j++) {
        tmpArr[j] = splitArr[i].get(j);
      }
      outArr[i] = tmpArr.clone();

    }

    return outArr;

  }

  /**
   * Inline comparator class to allow the comparison of two int arrays
   * by their second value.
   */
  static final Comparator<int[]> COMPARE_BY_SECOND = new Comparator<int[]>() {
    public int compare(int[] a, int[] b) {
      if (a[1] == b[1]) {
        return 0;
      } else if (a[1] < b[1]) {
        return -1;
      } else {
        return 1;
      }
    }
  };

  /**
   * Deep-clones a two dimensional float array. Quick and dirty, but gets the
   * job done.
   *
   * @param inArr   The array to clone.
   * @return        A completely seperate copy of the array that can be
   *                changed without altering the original.
   */
  public float[][] cloneFloatArr(float inArr[][]) {
    float outArr[][] = new float[inArr.length][];
    for (int i = 0; i < inArr.length; i++) {
      outArr[i] = inArr[i].clone();
    }
    return outArr;
  }

  /**
   * Returns the total *minimum* distance between an input array and a set of
   * reference patterns using the DTW algorithm.
   *
   * @param inArr       The input array that is to be checked.
   * @param refArr      A list of reference patterns to compare against.
   * @param commands    Extra commands for normalisation.
   *
   * @return            The total minimum distance from the input to the
   *                    reference patterns.
   */
  public float getTotalDist(float[][][] inArr, float[][][] refArr, String[] commands) {

    float sumDist = 0;

    float dists[][] = DTWDist.dtw(inArr, refArr, commands);

    // For each character, find the lowest distance and sum
    // over all of the characters.
    for (int i = 0; i < dists.length; i++) {

      float tmpDist = dists[i][0];
      for (int j = 1; j < dists[i].length; j++) {
        tmpDist = Math.min(tmpDist, dists[i][j]);
      }

      sumDist += tmpDist;
    }

    return sumDist;
  }

}
