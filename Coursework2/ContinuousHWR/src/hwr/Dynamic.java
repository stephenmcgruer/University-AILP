import hwr.*;

/**
 * Used to run the One-Stage DP system for a set of inputs and outputs.
 */
public class Dynamic {

  /**
   * Runs the DTW algorithm on a set of files given as arguments.
   *
   * @param args  There should be two basic arguments - a file which
   *              contains an input template and a file containing a list of
   *              reference templates.
   */
  public static void main(String[] args) {

    if (args.length < 2) {
      System.err.println("Usage: java Dynamic input_file ref_file");
      System.exit(-1);
    }

    float input_pats[][];
    float ref_pats[][][] = new float[1][][];

    // Get the input and reference patterns.
    PenDataReader reader = new PenDataReader(true);
    input_pats = reader.readFile(args[0]);
    ref_pats = reader.readFileList(args[1]);

    // Apply the One Stage dp to the input/references
    OneStageDP dp = new OneStageDP(new SquaredEuclidDistance());
    int output[] = dp.recognise(input_pats, ref_pats);

    // Output the resultant classification.
    for (int i = 0; i < output.length; i++) {
      System.out.print(output[i] + " ");
    }
    System.out.println(":");

  }

}
