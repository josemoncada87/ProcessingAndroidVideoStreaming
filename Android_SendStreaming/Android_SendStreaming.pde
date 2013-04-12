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
  values = new byte[176*144];
  cam = new KetaiCamera(this, 176, 144, 24);     
  try {
    ds =  new DatagramSocket(5004);
  } 
  catch(Exception e) {
    println("init Socket error: " + e);
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
    ba = new ByteArrayOutputStream(176*144);
    im = Bitmap.createBitmap( cam.pixels, 176, 144, Bitmap.Config.RGB_565);
    im.compress(Bitmap.CompressFormat.JPEG, 75, ba);
  } 
  catch(Exception e) {
    println("onCameraPreview error : " + e);
    //  e.printStackTrace(); // more info?
  }
  try {
    byte[] val = ba.toByteArray();
    ds.send( new DatagramPacket(val, val.length, InetAddress.getByName("192.168.1.50"), 5001)); // 5001 port
  } 
  catch(Exception e) {
    println("android: " + e);
    //  e.printStackTrace();
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

