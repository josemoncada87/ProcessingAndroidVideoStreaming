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
  } 
  catch(Exception e) {
    println("iniSocket: " + e);
  }
}

void draw() {
  image(cam, width/2, height/2, 640, 480);
}

void onCameraPreviewEvent() {
  cam.read();  
  ByteArrayOutputStream ba = null;
  Bitmap im = null;
  try {
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
    }
  } 
  catch(Exception e) {
    println("u1: " + e);
  }
  try {
    byte[] val = ba.toByteArray();
    ds.send( new DatagramPacket(val, val.length, InetAddress.getByName("192.168.1.50"), 5001));   
  } 
  catch(Exception e) {
    println("android eeror on camera: " + e);
  }
}

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

