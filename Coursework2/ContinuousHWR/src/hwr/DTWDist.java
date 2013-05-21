package hwr;
import java.util.ArrayList;

/**
 * Runs the Dynamic Timewarping algorithm on a set of inputs and reference templates.
 */
public class DTWDist {

  /**
   * Used to run the dynamic timewarping algorithm on a set of input and
   * reference patterns, applying any options specified for pre-processing
   * the data (mean, scale, slant, smoothing).
   *
   * @param input_pats  An array of input patterns.
   * @param ref_pats    An array of reference patterns.
   * @param args    Preprocessing commands - mean, scale, slant, smooth.
   */
  public static float[][] dtw(float[][][] input_pats, float[][][] ref_pats, String[] args) {

    TimeWarping warpFun = new DynamicTimeWarping(new SquaredEuclidDistance());
    ArrayList<Normalisation> commands = new ArrayList<Normalisation>();

    // Get which normalisations we are to use, if any.
    if (args.length > 0) {
      for (int i = 0; i < args.length; ++i) {
        // I hate that Java can't switch over strings...
        // (And I'm too lazy to do an enum or hashmap.)
        if (args[i].equals("mean")) { 
          commands.add(new MeanNormalisation());
        } else if (args[i].equals("scale")) {
          commands.add(new ScaleNormalisation()); 
        }
      }
    }

    // Normalise the input and reference data, based on the passed commands.
    if (args.length > 0) {
      
      // Input data.
      for (int i = 0; i < input_pats.length; ++i) {
        for (int j = 0; j < commands.size(); ++j) {
          input_pats[i] = commands.get(j).normalise(input_pats[i]);
        }
      }
    
      // Ref data.
      for (int i = 0; i < ref_pats.length; ++i) {
        for (int j = 0; j < commands.size(); ++j) {
          ref_pats[i] = commands.get(j).normalise(ref_pats[i]);
        }
      }

    }

    // Perform the DTW algorithm on the input patterns and reference patterns.
    
    float retArr[][] = new float[input_pats.length][ref_pats.length];

    for (int i = 0; i < retArr.length; i++) {
      for (int j = 0; j < retArr[i].length; j++) {
        retArr[i][j] = warpFun.calcDistance(input_pats[i], ref_pats[j]);
      }
    }

    return retArr;
    
  }

}
