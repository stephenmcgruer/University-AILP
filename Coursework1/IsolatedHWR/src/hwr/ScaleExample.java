import hwr.*;

public class ScaleExample {

  public static void main(String[] args) {

    if (args.length != 1) {
      System.err.println("Usage: java ScaleExample file_name");
      System.exit(1);
    }

    PenDataReader reader = new PenDataReader(true);
    float[][] points = reader.readFile(args[0]);

    ScaleNormalisation scaleN = new ScaleNormalisation();
    points = scaleN.normalise(points, 100);

    for (int i = 0; i < points.length; ++i) {

      System.out.println(points[i][0] + " " + points[i][1] + " 1");

    }


  }

}
