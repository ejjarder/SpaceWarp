/*************************************************************************
 *  Author: Eugene Jarder
 *
 *  A class that loads and plays images loaded from a specified folder.
 *  Folder must be present in the sketch's data folder.
 *
 *************************************************************************/
import java.io.File;

class MoviePlayer
{
  private PImage [] images;       // contains the images in the movie
  private float currentFrame = 0; // the current frame of the playback
  private int xPos = 0;           // stores the x position of the movie 
  private int yPos = 0;           // stores the y position of the movie
  private float speed = 1.0;      // the playback speed
  private int brightness = 255;   // determines the brightness of the
                                  // image to draw
  private int alpha = 255;        // the transparency of the images to draw
                                  
  /**
   * Loads the images in the folder to the images array.
   * The images will be loaded, stored, and played back in alphabetical
   * order.
   *   
   * @param folder The folder containing the images of the movie
   */
  public MoviePlayer(String folderName)
  {
    File folder = new File(dataPath(folderName));

    String[] filenames = folder.list();

    images = new PImage[filenames.length];
    
    for (int imageIndex = 0; imageIndex < filenames.length; ++imageIndex)
    {
      String fullPath =
        String.format("%s/%s", folderName, filenames[imageIndex]);
      images[imageIndex] = loadImage(fullPath);
    }
  }
  
  /**
   * Set the playback speed
   *   
   * @param speed The new playback speed
   */
  public void setSpeed(float speed)
  {
    this.speed = speed;
  }
  
  /**
   * Set the brightness
   *   
   * @param brightness The new brightness
   */
  public void setBrightness(int brightness)
  {
    this.brightness = brightness;
  }
  
  /**
   * Set the alpha
   *   
   * @param alpha The new alpha
   */
  public void setAlpha(int alpha)
  {
    this.alpha = alpha;
  }
  
  /**
   * Draws the current frame.
   */
  void drawFrame()
  {
    tint(brightness, alpha);
    image(images[(int)currentFrame], xPos, yPos);
  }
  
  /**
   * Advances the frame based on the speed. Loops it back to 0 after
   * finishing the movie.
   */
  void advanceFrame()
  {
    currentFrame += images.length + 1 * speed;
    currentFrame %= images.length;
  }
}

