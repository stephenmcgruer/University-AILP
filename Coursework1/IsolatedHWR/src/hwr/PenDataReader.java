package hwr;

import java.lang.*;
import java.io.*;
import java.util.*;

/**
 * Class used for reading in data in IIPL format and converting
 * it to float vectors.
 */
public class PenDataReader {

  boolean ignorePenUp;

  /**
   * Class constructor - sets the ignorePenUp variable.
   */
  public PenDataReader(boolean ignorePenUp) {
    this.ignorePenUp = ignorePenUp;
  }

  /**
   * Reads a file containing IIPL data and formats
   * it into a 2d array, discarding the stroke data.
   *
   * @param file    The file to read from.
   * 
   * @return        A 2d array of points.
   */
  public float[][] readFile(String file) {

    // A vector is used locally for convienence.
    Vector v = new Vector();

    try {

      BufferedReader input = new BufferedReader(new FileReader(file));
      String line;

      // Parse each line, recording the x and y values.
      while ((line = input.readLine()) != null) {

        StringTokenizer st = new StringTokenizer(line);

        while (st.hasMoreTokens()) {
          float d[] = new float[3];
          d[0] = Float.parseFloat(st.nextToken());
          d[1] = Float.parseFloat(st.nextToken());
          int id  = Integer.parseInt(st.nextToken()); 
          d[2] = id;
          if (st.hasMoreTokens()) {
            // Parses the time value (not currently used.)
            int time = Integer.parseInt(st.nextToken());
          }
          // ?
          if (id == 0 && ignorePenUp)
            continue;
          else {
            v.addElement(d);
          }
        }
      }

      input.close();

    } catch (IOException ex) {
      System.err.println("Error when loading " + file);
    }

    // Convert the vector into an array.
    float a[][] = new float[v.size()][3];
    for (int i = 0; i < v.size(); ++i) {
      float d[] = (float[])v.get(i);
      a[i][0] = d[0];
      a[i][1] = d[1];
      a[i][2] = d[2];
    }

    return a;

  }

  /**
   * Reads IIPL data from an input stream and parses it in to
   * a 2d array of points, discarding stroke data.
   */
  public float[][] readStream(InputStream in) {

    // A vector is used locally for convienence.
    Vector v = new Vector();

    try {

      BufferedReader input = new BufferedReader(new InputStreamReader(in));
      String line;
      
      // While there are still more input lines to read, parse them in to
      // the correct format.
      while ((line = input.readLine()) != null && line.trim().length() > 0) {

        StringTokenizer st = new StringTokenizer(line);

        while (st.hasMoreTokens()) {
          float d[] = new float[3];
          d[0] = Float.parseFloat(st.nextToken());
          d[1] = Float.parseFloat(st.nextToken());
          int id  = Integer.parseInt(st.nextToken()); 
          d[2] = id;
          if (id == 0 && ignorePenUp)
            continue;
          else {
            v.addElement(d);
          }
        }
      }

      // If there is no input, then return either
      // an empty array or null, depending on if
      // the input stream was null.
      if (v.isEmpty()) {
        if (line != null) {
          float a[][] = new float[0][0];
          return a;
        } else
          return null;
      }
    } catch (IOException ex) {
      System.err.println("Error when loading from InputStream");
    }

    // Convert the vector into an array.
    float a[][] = new float[v.size()][3];
    for (int i = 0; i < v.size(); ++i) {
      float d[] = (float[])v.get(i);
      a[i][0] = d[0];
      a[i][1] = d[1];
      a[i][2] = d[2];
    }

    return a;

  }

  /**
   * Wrapper method for readFile, reading a list of files in to
   * a 3d array.
   *
   * @param fileList    The list of files to read.
   * 
   * @return            A 3d array of the files and their points.
   */
  public float[][][] readFileList(String filelist) {

    // A vector is used locally for convienence.
    Vector v = new Vector();

    try {
      BufferedReader input = new BufferedReader(new FileReader(filelist));
      String file;
      while ((file = input.readLine()) != null) {
        file = file.trim();
        if (file.length() > 0) 
          v.addElement(readFile(file));
      }
      input.close();
    } catch (IOException ex) {
      System.err.println("Error when loading from filelist:" + filelist);
    }

    // Convert the vector into an array.
    float a[][][] = new float[v.size()][][];
    for (int i = 0; i < v.size(); ++i) {
      a[i] = (float[][])v.get(i);
    }
    return a;

  }

}
