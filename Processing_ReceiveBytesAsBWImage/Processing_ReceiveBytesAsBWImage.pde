import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

DatagramSocket ds;

byte[] espacio;
byte[] rec;
PImage temp;

void setup() {  
  size(500, 500);
  espacio = new byte[176*144];
  rec = new byte[176*144];
  try {
    ds = new DatagramSocket(5000);    
  }
  catch(Exception e) {
    println(e);
  }
  temp = createImage( 176, 144, RGB );
}

void draw() {  
  background(255);
  espacio = new byte[176*144];
  rec = new byte[176*144];
  dp = new DatagramPacket(espacio, espacio.length);
  try {
    ds.receive(dp);
    rec = dp.getData();
  }
  catch(Exception e) {
    println("pc: " + e);
  }
  for (int i = 0 ; i < rec.length ; i++) {
    if (rec[i] == 1) {
      temp.pixels[i] = #FFFFFF;
    }
    else {
      temp.pixels[i] = #000000;
    }
  }
  image(temp, 0,0);
}

