import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.lang.StringBuilder;

/**
 * Represents a dictionary lookup for a word against a 
 * set dictionary, using the Levenshtein distance.
 *
 * See here: http://en.wikipedia.org/wiki/Levenshtein_distance
 */
public class DictionaryLookup {

  public static void main(String[] args) {

    if (args.length < 2) {
      System.out.println("Usage: java DictionaryLookup input_file dictionary_file");
      System.exit(-1);
    }

    String input = "";
    Scanner sc = null;
    
    // Grab the input.
    try {
      sc = new Scanner(new File(args[0]));
      if (sc.hasNextLine()) {
        input = sc.nextLine();
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      System.exit(-1);
    } finally {
      sc.close();
    }

    // Find the search string.
    String columns[] = input.split("\\s\\s*");
    StringBuilder sb = new StringBuilder();
    StringBuilder extra = new StringBuilder();

    for (int i = 0; i < columns.length; i++) {

      if (columns[i].equals(":")) {
        extra.append(columns[i]);
        extra.append(" ");
      } else {
        sb.append(columns[i]);
      }

    }

    // Capitalize the string, so that we are
    // case insensitive.
    if (Character.isLowerCase(sb.charAt(0))) {
      sb.setCharAt(0, Character.toUpperCase(sb.charAt(0)));
    }
    for (int i = 1; i < sb.length(); i++) {
      if (Character.isUpperCase(sb.charAt(i))) {
        sb.setCharAt(i, Character.toLowerCase(sb.charAt(i)));
      }
    }
    String searchString = sb.toString();

    // Find the closest word to the search string.
    
    int closestDist = 1000;
    String closestWord = "";

    try {
      sc = new Scanner(new File(args[1]));
      while (sc.hasNextLine()) {
        String line = sc.nextLine();
        int tempDist = editDistance(searchString, line);
        if (tempDist < closestDist) {
          closestDist = tempDist;
          closestWord = line;
        }
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      System.exit(-1);
    } finally {
      sc.close();
    }

    System.out.println(closestWord + " " + extra.toString());

  }

  private static int editDistance(String s, String t) {

    int m = s.length();
    int n = t.length();

    int d[][] = new int[m+1][n+1];

    for (int i = 0; i <= m; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      d[0][j] = j;
    }

    for (int j = 1; j <= n; j++) {
      for (int i = 1; i <= m; i++) {
        if (s.charAt(i-1) == t.charAt(j-1)) {
          d[i][j] = d[i-1][j-1];
        } else {
          d[i][j] = minThree(d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + 1);
        }
      }
    }

    return d[m][n];

  }

  private static int minThree(int a, int b, int c) {
    if (a < b) {
      return (a < c) ? a : c;
    } else {
      return (b < c) ? b : c;
    }
  }

}
