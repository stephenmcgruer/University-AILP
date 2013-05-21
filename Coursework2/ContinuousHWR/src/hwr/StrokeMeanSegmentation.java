package hwr;

import java.lang.Math;
import java.util.ArrayList;
import java.lang.Float;
import java.lang.UnsupportedOperationException;

/**
 * StrokeMeanSegmentation extends the Segmentation class to 
 * provide segmentation of a word based on the centre of mass
 * of each stroke in the word.
 */
public class StrokeMeanSegmentation extends Segmentation {

  /**
   * Segments an input word using stroke segmentation with a
   * centre of mass filter, returning an array of characters
   * (that is, an array of arrays of points, where a point
   * is a 3-tuple of x, y and stroke.) Assumes that the input
   * is correctly formed.
   *
   * @param inArr   The input word - an array of points, with
   *                stroke information.
   */
  public float[][][] hardSegment(float[][] inArr) throws UnsupportedOperationException {

    // Is that a float array nested inside an arraylist nested inside another
    // arraylist? Why yes, yes it is.
    ArrayList<ArrayList<float[]>> characters = new ArrayList<ArrayList<float[]>>();
    ArrayList<float[]> character = new ArrayList<float[]>();
    ArrayList<Float> centreOfMasses = new ArrayList<Float>();

    float prevPoint[] = inArr[0];

    // We make a run through to find the approximate width of our input. Since
    // words tend to be written sideways, we just take the x-axis as the 
    // difference. Also calculate the centre of masses for each stroke.
    
    float minX = inArr[0][0];
    float maxX = inArr[0][0];
    float prevStroke = inArr[0][2];
    float meanPoint = inArr[0][0];
    int numPoints = 1;
    
    for (int i = 1; i < inArr.length; i++) {
    	
      maxX = Math.max(maxX, inArr[i][0]);
      minX = Math.min(minX, inArr[i][0]);

      // New stroke, so calculate the mean and add it
      // to the array of centre of masses.
      if (inArr[i][2] != prevStroke) {
        meanPoint /= numPoints;
        centreOfMasses.add(new Float(meanPoint));
        meanPoint = 0;
        numPoints = 1;
        prevStroke = inArr[i][2];
      }

      meanPoint += inArr[i][0];
      numPoints++;

    }
    // Add the final stroke's mean.
    meanPoint /= numPoints;
    centreOfMasses.add(new Float(meanPoint));
    
    // dist is the maximum distance between two strokes before we consider
    // them seperate strokes.
    float dist = (maxX - minX)/10;

    // Separate the characters.
    // For each character, when the stroke changes check if the distance
    // between the two centre-of-masses is <= distance or not.
    for (float[] point : inArr) {
      if (point[2] != prevPoint[2]) {
    	  
        float tmpDist = Math.abs(centreOfMasses.get(Math.round(point[2])-1) - centreOfMasses.get(Math.round(prevPoint[2])-1));
        if (tmpDist > dist) {
          characters.add(cloneArrayList(character));
          character = new ArrayList<float[]>();
          prevPoint = point;
        } 
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
  
  //Cannot (easily!) do soft segmentation based on strokes with centre of mass calculations.
  // TODO: Perhaps begin by combining strokes, then start adding them in based on the biggest (longest?)
  // stroke first? But how to order?
  public float[][][] softSegment(float[][] inArr, float[][][] refArr) throws UnsupportedOperationException {
	  throw new UnsupportedOperationException("Cannot do soft stroke-based (with centre of mass filter) segmentation!");
  }

  /**
   * Quick and dirty implementation for cloning an arraylist of
   * float arrays. 
   */
  private ArrayList<float[]> cloneArrayList(ArrayList<float[]> inArrList) {
    ArrayList<float[]> retArrList = new ArrayList<float[]>();
    for (int i = 0; i < inArrList.size(); i++) {
      retArrList.add(inArrList.get(i).clone());
    }
    return retArrList;
  }

}
