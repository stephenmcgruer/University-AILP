import hwr.*;

/**
 * Used to run a hard or soft segmentation system for a set of inputs and outputs.
 */
public class Segmented  {

  /**
   * Runs the DTW algorithm on a set of files given as arguments.
   *
   * @param args  There should be four basic arguments - a file which
   *              contains an input template, a file containing a list of
   *              reference templates, the segmentation class to use and
   *              what type of segmentation to use. Any additional
   *              arguments will be processed as normalisation commands -
   *              mean, scale, slant, smoothing, etc.
   */
  public static void main(String[] args) {

    if (args.length < 4) {
      System.err.println("Usage: java Segmented input_file ref_file " +
                          "segmentation_class segmentation_type [commands...]");
      System.exit(-1);
    }

    float input_pats[][];
    float ref_pats[][][] = new float[1][][];

    // Grab the input and reference patterns from the file.
    PenDataReader reader = new PenDataReader(true);
    input_pats = reader.readFile(args[0]);
    ref_pats = reader.readFileList(args[1]);

    // Choose the segmentation method.
    Segmentation seg = null;

    if (args[2].equals("StrokeSegmentation")) {
      seg = new StrokeSegmentation();
    } else if (args[2].equals("StrokeMeanSegmentation")) {
      seg = new StrokeMeanSegmentation();
    } else if (args[2].equals("HistogramSegmentation")) {
      seg = new HistogramSegmentation();
    } else {
      System.err.println("ERROR: Unrecognized segmentation method.");
      System.exit(-1);
    }

    // Apply the correct form of segmentation (hard/soft).
    float segmented_inputs[][][] = null;
    if (args[3].equals("soft")) {
    	segmented_inputs = seg.softSegment(input_pats, ref_pats);
    } else if (args[3].equals("hard")) {
    	segmented_inputs = seg.hardSegment(input_pats);
    } else {
    	System.err.println("ERROR: Unrecognized segmentation type.");
    	System.exit(-1);
    }

    // Grab any commands to apply to the final result.
    String commands[] = new String[args.length - 4];
    for (int i = 4; i < args.length; i++) {
      commands[i-4] = args[i];
    }

    // Perform the dynamic timewarping matching.
    float output[][] = DTWDist.dtw(segmented_inputs, ref_pats, commands);

    // Output the recognition distances.
    for (int i = 0; i < output.length; i++) {
      for (int j = 0; j < output[i].length; j++) {
        System.out.println(i + " " + j + "\t" + output[i][j]);
      }
      System.out.println();
    }
    System.out.println();

  }

}
