import hwr.*;

public class SlantExample {

  public static void main(String[] args) {

    if (args.length != 1) {
      System.err.println("Usage: java SlantExample file_name");
      System.exit(1);
    }

    PenDataReader reader = new PenDataReader(true);
    float[][] points = reader.readFile(args[0]);

    Normalisation slantN = new SlantNormalisation();
    points = slantN.normalise(points);

    for (int i = 0; i < points.length; ++i) {

      System.out.println(points[i][0] + " " + points[i][1] + " 1");

    }


  }

}
