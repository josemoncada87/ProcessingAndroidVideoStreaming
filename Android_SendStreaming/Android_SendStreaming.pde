/**
 * <p>Ketai Sensor Library for Android: http://KetaiProject.org</p>
 *
 * <p>Ketai Camera Features:
 * <ul>
 * <li>Interface for built-in camera</li>
 * <li></li>
 * </ul>
 * <p>Updated: 2012-10-21 Daniel Sauter/j.duran</p>
 */
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.io.ByteArrayOutputStream;
import android.graphics.Bitmap;
import ketai.camera.*;

KetaiCamera cam;
byte[] values;
DatagramSocket ds;


void setup() {
  orientation(LANDSCAPE);
  imageMode(CENTER);
  frameRate(15);
  values = new byte[176*144];
  cam = new KetaiCamera(this, 176, 144, 15);  
   
  try {
    ds =  new DatagramSocket(5004);
  } catch(Exception e) {
      println("iniSocket: " + e);
    }
  }

  void draw() {
    //text(frameRate, 100, 100);
    image(cam, width/2, height/2, 640, 480);
  }

  void onCameraPreviewEvent() {
    cam.read();  
    ByteArrayOutputStream ba = null;
    Bitmap im = null;
    try {
    ba = new ByteArrayOutputStream(176*144);
    im = Bitmap.createBitmap( cam.pixels , 176, 144, Bitmap.Config.RGB_565);
    im.compress(Bitmap.CompressFormat.JPEG, 75, ba);     
   /*  //(Bitmap.CompressFormat format, int quality, OutputStream stream)//
    for (int i = 0 ; i < cam.pixels.length ; i++) {
      color c = cam.pixels[i];
      float r =  c >> 16 & 0xFF;
      float g = c >> 8 & 0xFF;
      float b = c & 0xFF;
      if ( (r+g+b)/3 > 120) {
        cam.pixels[i] = #FFFFFF;
        values[i] = 1;
      }
      else {
        cam.pixels[i] = #000000;
        values[i] = 0;
      }
    }*/
    } catch(Exception e) {
        println("u1: " + e);
      //  e.printStackTrace();
      }
    
    
    try {
      // 192.168.1.51 
     byte[] val = ba.toByteArray();
    // println("tamano: " + val.length );
     ds.send( new DatagramPacket(val, val.length, InetAddress.getByName("192.168.1.50"), 5001));
      //(byte[] buf, int length, InetAddress address, int port) 
    } catch(Exception e) {
        println("android: " + e);
      //  e.printStackTrace();
      }
    }

    // start/stop camera preview by tapping the screen
    void mousePressed()
    {
      if (cam.isStarted())
      {
        cam.stop();
      }
      else
        cam.start();
    }
    void keyPressed() {
      if (key == CODED) {
        if (keyCode == MENU) {
          if (cam.isFlashEnabled())
            cam.disableFlash();
          else
            cam.enableFlash();
        }
      }
    }

