import processing.core.*; 
import processing.xml.*; 

import java.awt.image.*; 
import javax.imageio.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class VideoReceiverThread extends PApplet {

// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP to receive images

 


PImage video1;
PImage video2;

ReceiverThread thread1;
ReceiverThread thread2;

public void setup() {
  size(800,300);
  video1 = createImage(176, 144,RGB);
  video2 = createImage(176, 144,RGB);  
  thread1 = new ReceiverThread(video1.width,video1.height,5001);
  thread2 = new ReceiverThread(video2.width,video2.height,5000);
  thread1.start();
  thread2.start();
}

 public void draw() {
  if (thread1.available()) {
    video1 = thread1.getImage();
  }
  
  if (thread2.available()) {
    video2 = thread2.getImage();
  }

  // Draw the image
  background(255);
  imageMode(CENTER);
  image(video1,width/4,height/2,176*2,144*2);
  image(video2,3*(width/4),height/2,176*2,144*2);
  
  //println("...");
}



// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP

class ReceiverThread extends Thread {

  // Port we are receiving.
  int port = 0; 
  DatagramSocket ds; 
  // A byte array to read into (max size of 65536, could be smaller)
  byte[] buffer = new byte[8000]; 

  boolean running;    // Is the thread running?  Yes or no?
  boolean available;  // Are there new tweets available?

  // Start with something 
  PImage img;

  ReceiverThread (int w, int h, int port) {
    this.port = port;
    img = createImage(w,h,RGB);
    running = false;
    available = true; // We start with "loading . . " being available

    try {
      ds = new DatagramSocket(port);
    } catch (SocketException e) {
      println(e);
      e.printStackTrace();
    }
    println("puerto: " + port);
  }

  public PImage getImage() {
    // We set available equal to false now that we've gotten the data
    available = false;
    return img;
  }

  public boolean available() {
    return available;
  }

  // Overriding "start()"
  public void start () {
    running = true;
    super.start();
  }

  // We must implement run, this gets triggered by start()
  public void run () {
    while (running) {
      checkForImage();
      // New data is available!
      available = true;
      try{
       sleep(3);
      }catch(Exception e){       
      }
    }
  }

  public void checkForImage() {
    DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
    try {
      ds.receive(p);
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    byte[] data = p.getData();

    //println("Received datagram with " + data.length + " bytes." );

    // Read incoming data into a ByteArrayInputStream
    ByteArrayInputStream bais = new ByteArrayInputStream( data );

    // We need to unpack JPG and put it in the PImage img
    img.loadPixels();
    try {
      // Make a BufferedImage out of the incoming bytes
      BufferedImage bimg = ImageIO.read(bais);
      // Put the pixels into the PImage
      bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    // Update the PImage pixels
    img.updatePixels();
  }


  // Our method that quits the thread
  public void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // In case the thread is waiting. . .
    interrupt();
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "VideoReceiverThread" });
  }
}
