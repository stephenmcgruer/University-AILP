package hwr;

import java.util.ArrayList;
import java.lang.UnsupportedOperationException;

/**
 * StrokeSegmentation extends the Segmentation class to 
 * provide basic segmentation of a word based on strokes.
 */
public class StrokeSegmentation extends Segmentation {

  /**
   * Segments an input word using basic stroke segmentation,
   * returning an array of characters (that is, an array
   * of arrays of points, where a point is a 3-tuple of x,
   * y and stroke.) Assumes that the input is correctly formed.
   *
   * @param inArr   The input word - an array of points, with
   *                stroke information.
   */
  public float[][][] hardSegment(float[][] inArr) throws UnsupportedOperationException {

    // Is that a float array nested inside an arraylist nested inside another
    // arraylist? Why yes, yes it is.
    ArrayList<ArrayList<float[]>> characters = new ArrayList<ArrayList<float[]>>();
    ArrayList<float[]> character = new ArrayList<float[]>();

    float prevPoint[] = inArr[0];

    // Seperate the characters.
    for (float[] point : inArr) {
      if (point[2] != prevPoint[2]) {
        characters.add(cloneArrayList(character));
        character = new ArrayList<float[]>();
        prevPoint = point;
      }
      character.add(point);
    }
    characters.add(cloneArrayList(character));

    // Convert the arraylists to static arrays.
    float charArr[][][] = new float[characters.size()][][];
    for (int i = 0; i < charArr.length; i++) {
      charArr[i] = new float[characters.get(i).size()][];
      for (int j = 0; j < charArr[i].length; j++) {
        charArr[i][j] = characters.get(i).get(j);
      }
    }

    return charArr;

  }
  
  // Cannot (easily!) do soft segmentation based on strokes.
  // TODO: Perhaps consider entire word first, then pick out largest strokes one after another and check
  // distance each time?
  public float[][][] softSegment(float[][] inArr, float[][][] refArr) throws UnsupportedOperationException {
	  throw new UnsupportedOperationException("Cannot do soft stroke-based segmentation!");
  }

  /**
   * Quick and dirty method for cloning an arraylist of float arrays. 
   */
  private ArrayList<float[]> cloneArrayList(ArrayList<float[]> inArrList) {
	  
    ArrayList<float[]> retArrList = new ArrayList<float[]>();
    for (int i = 0; i < inArrList.size(); i++) {
      retArrList.add(inArrList.get(i).clone());
    }
    return retArrList;
  }

}
