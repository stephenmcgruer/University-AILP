package hwr;

import java.lang.UnsupportedOperationException;

/**
 * An abstract class representing a segmentation technique.
 */
public abstract class Segmentation {

  public abstract float[][][] hardSegment(float[][] inArr) throws UnsupportedOperationException;
  
  public abstract float[][][] softSegment(float[][] inArr, float[][][] refArr) throws UnsupportedOperationException;

}

