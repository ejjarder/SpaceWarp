/*************************************************************************
 * SpaceWarp.pde 
 * 
 * Author: Eugene Jarder
 *
 * For completion of requirements for Creative Programming for Digital 
 * Media & Mobile Apps at Coursera.
 *
 * It will start off in the "Earth State". Clicking on the screen will
 * unpause the video and play the audio. Clicking and dragging the mouse
 * along the height will change the state. If the mouse is dragged to the
 * bottom part of the screen, it transitions to the "Warp State". Both
 * states have different animations, as well as different audio.
 *
 * - Earth State
 *   - Video - spinning earth
 *   - http://www.partnersinrhyme.com/video/video/7596.html
 *   - Speeds up as mouse approaches the right side of screen, slows down
 *     in the middle, and reverses at the left side of the screen
 *   - Audio - low humming engine
 *   - https://www.freesound.org/people/AniCator/sounds/100482/
 *   - Normal speed at the edges of screen, almost stopped at the middle
 * - Warp State
 *   - Video - yellow warp
 *   - http://www.partnersinrhyme.com/video/video/7583.html
 *   - Audio - warping sound
 *   - https://www.freesound.org/people/Erokia/sounds/185844/
 *   - Both audio and video speed up as the mouse approaches the middle
 *     horizontally.
 *
 * Positioning the mouse in the middle vertically will show a transition
 * between the two states.
 * 
 * Clicking again while the sketch is playing will pause the video and
 * audio. Clicking yet again will resume playback.
 *
 *************************************************************************/

// Speed constants - used for sound and video playback
private static final float SPEED_MIN = -1.0;
private static final float SPEED_MAX = 1.0;

// Video brightness min and max values
private static final int BRIGHTNESS_MIN = 50;
private static final int BRIGHTNESS_MAX = 255;

// Audio volume min and max values
private static final float VOLUME_MIN = 0.1;
private static final float VOLUME_MAX = 1.0;

// Video brightness min and max values
private static final int ALPHA_MIN = 20;
private static final int ALPHA_MAX = 230; 

// Needed for audio
private Maxim maxim;

// store the videos here
private MoviePlayer earthPlayer;
private MoviePlayer warpPlayer;

// store the audio here
private AudioPlayer enginePlayer;
private AudioPlayer warpSoundPlayer;

// controls whether the video and sounds are playing or not
private boolean playing;

/**
 * Initialize the sketch
 */
void setup()
{
  // This is the size of the videos used
  size(420, 236);
  background(0);

  initializeVideo();
  initializeAudio();

  playing = false;
}

/**
 * Initialize the videos to play
 */
void initializeVideo()
{
  earthPlayer = new MoviePlayer("video/earth");
  earthPlayer.setSpeed(SPEED_MAX);
  earthPlayer.setBrightness(BRIGHTNESS_MAX);
  earthPlayer.setAlpha(255);

  warpPlayer = new MoviePlayer("video/warp");
  warpPlayer.setSpeed(SPEED_MIN);
  warpPlayer.setBrightness(BRIGHTNESS_MAX);
  warpPlayer.setAlpha(ALPHA_MIN);
  
  drawOneFrame(); // draw one frame, just so it won't be blank.
}

/**
 * Initialize the audios to play
 */
void initializeAudio()
{
  maxim = new Maxim(this);

  enginePlayer = maxim.loadFile("audio/engine.wav");
  enginePlayer.setLooping(true);
  enginePlayer.speed(SPEED_MAX);
  enginePlayer.volume(VOLUME_MAX);
  
  warpSoundPlayer = maxim.loadFile("audio/warp.wav");
  warpSoundPlayer.setLooping(true);
  warpSoundPlayer.speed(SPEED_MAX);
  warpSoundPlayer.volume(VOLUME_MIN);
}

/**
 * Main loop. Only does something if it's in the playing state
 */
void draw()
{
  if (playing)
  {
    drawOneFrame();
  }
}

void drawOneFrame()
{
  earthPlayer.drawFrame();
  earthPlayer.advanceFrame();

  warpPlayer.drawFrame();
  warpPlayer.advanceFrame();
}

/**
 * Start and stop the playing of the video. 
 * Sound playback is triggered here as well.
 */
void mouseClicked()
{
  playing = !playing;
  
  triggerSounds(playing);
}

/**
 * Trigger the sound 
 */
void triggerSounds(boolean playSound)
{
  if (playSound)
  {
    enginePlayer.play();  
    warpSoundPlayer.play();
  }
  else
  {
    enginePlayer.stop();  
    warpSoundPlayer.stop();
  }
}

/**
 * Compute the different values that control the audio and video.
 * Will only compute values if the animation is playing.
 */
void mouseDragged()
{
  if (playing)
  {
    computeEarthVariables();
    computeWarpVariables();
  }
}

/**
 * Compute the different values that control the earth state
 */
void computeEarthVariables()
{
  float earthSpeed = map(mouseX, 0, width, SPEED_MIN, SPEED_MAX);
  
  earthPlayer.setSpeed(earthSpeed);
  earthPlayer.setBrightness(
  (int)(map(mouseY, height, 0, BRIGHTNESS_MIN, BRIGHTNESS_MAX)));

  enginePlayer.speed(abs(earthSpeed));  
  enginePlayer.volume(
  map(mouseY, height, 0, VOLUME_MIN, VOLUME_MAX));
}

/**
 * Compute the different values that control the warp state
 */
void computeWarpVariables()
{
  float warpSpeed = map(abs(mouseX - (width / 2)), width / 2, 0, 0, SPEED_MAX);

  warpPlayer.setSpeed(warpSpeed);
  warpPlayer.setAlpha(
    (int)(map(mouseY, 0, height, ALPHA_MIN, ALPHA_MAX)));

  warpSoundPlayer.speed(abs(warpSpeed));  
  warpSoundPlayer.volume(
  map(mouseY, 0, height, VOLUME_MIN, VOLUME_MAX));
}

