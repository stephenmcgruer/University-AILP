import hwr.*;

public class MeanExample {

  public static void main(String[] args) {

    if (args.length != 1) {
      System.err.println("Usage: java MeanExample file_name");
      System.exit(1);
    }

    PenDataReader reader = new PenDataReader(true);
    float[][] points = reader.readFile(args[0]);

    Normalisation meanN = new MeanNormalisation();
    points = meanN.normalise(points);

    for (int i = 0; i < points.length; ++i) {

      System.out.println(points[i][0] + " " + points[i][1] + " 1");

    }


  }

}
