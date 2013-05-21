import java.lang.*;
import java.io.*;
import java.util.*;
import hwr.*;

/**
 * The main class used to run a Dynamic Timewarping algorithm on a set
 * of inputs and reference templates.
 */
public class DTWDist {

  /**
   * Runs the DTW algorithm on a set of files given as arguments.
   *
   * @param args  There should be two arguments - the first a file which
   *              contains a list of input templates, the second a file
   *              containing a list of reference templates.
   */
  public static void main(String[] args) {

    if (args.length < 2) {
      System.out.println("Perform dynamic time warping alignment on reference patterns.");
      System.out.println("Usage: input_file ref_file [commands...]");
      System.out.println("Output format: input_id ref_id distance");
      System.exit(-1);
    }

    TimeWarping warpFun = new DynamicTimeWarping(new SquaredEuclidDistance());

    float input_pats[][][];
    float ref_pats[][][] = new float[1][][];
    ArrayList<Normalisation> commands = new ArrayList<Normalisation>();

    PenDataReader reader = new PenDataReader(true);
    input_pats = reader.readFileList(args[0]);
    ref_pats = reader.readFileList(args[1]);

    // Get which normalisations we are to use, if any.
    if (args.length > 2) {
      for (int i = 2; i < args.length; ++i) {
        // I hate that Java can't switch over strings...
        // (And I'm too lazy to do an enum or hashmap.)
        if (args[i].equals("mean")) { 
          commands.add(new MeanNormalisation());
        } else if (args[i].equals("scale")) {
          commands.add(new ScaleNormalisation()); 
        } else if (args[i].equals("slant")) {
          commands.add(new SlantNormalisation());
        } else if (args[i].equals("smooth")) {
          commands.add(new SmoothNormalisation());
        }
      }
    }

    // Normalise the input and reference data, based on the passed commands.
    if (args.length > 2) {
      
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

    // Used for testing normalisation.
    /*    
    for(int i = 0; i < input_pats.length; ++i) {
      for(int j = 0; j < input_pats[i].length; ++j) {
        System.out.println(input_pats[i][j][0] + " " + input_pats[i][j][1] + " 1");
      }
      System.out.println();
    }
    */
    


    // Output the DTW distance for each combination of input and
    // reference pattern. 
     
    for (int i = 0; i < input_pats.length; ++i) {
      for (int j = 0; j < ref_pats.length; ++j) {
        System.out.println(i + " " + j + "\t" + warpFun.calcDistance(input_pats[i], ref_pats[j]));
      }
      System.out.println();
    }
    System.out.println();
    
  }

}
