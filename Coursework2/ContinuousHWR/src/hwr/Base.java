import hwr.*;

/**
 * Used to run the baseline system for a set of inputs and outputs.
 */
public class Base {

  /**
   * Runs the DTW algorithm on a set of files given as arguments.
   *
   * @param args  There should be two arguments - the first a file which
   *              contains a list of input templates, the second a file
   *              containing a list of reference templates. Any additional
   *              arguments will be processed as normalisation commands -
   *              mean, scale, slant, smoothing, etc.
   */
  public static void main(String[] args) {

    if (args.length < 2) {
      System.out.println("Usage: java Base.java input_file ref_file [commands...]");
      System.exit(-1);
    }

    float input_pats[][][];
    float ref_pats[][][] = new float[1][][];

    // Read in the data from the files.
    PenDataReader reader = new PenDataReader(true);
    input_pats = reader.readFileList(args[0]);
    ref_pats = reader.readFileList(args[1]);

    // Grab any extra commands for normalisation.
    String commands[] = new String[args.length - 2];
    for (int i = 2; i < args.length; i++) {
      commands[i-2] = args[i];
    }

    // Perform the Dynamic Time-Warping matching.
    float output[][] = DTWDist.dtw(input_pats, ref_pats, commands);

    // Output the distances.
    for (int i = 0; i < output.length; i++) {
      for (int j = 0; j < output[i].length; j++) {
        System.out.println(i + " " + j + "\t" + output[i][j]);
      }
      System.out.println();
    }

  }

}
