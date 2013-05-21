package hwr;

/**
 * Abstract class which models a Timewarping distance calculation method.
 */
public abstract class TimeWarping {

  Distance distFun;

  public TimeWarping(Distance distFun) {
    this.distFun = distFun;
  }

  public abstract float calcDistance(float a[][], float b[][]);

}

