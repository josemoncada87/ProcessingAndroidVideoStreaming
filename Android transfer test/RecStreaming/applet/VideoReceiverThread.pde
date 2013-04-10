// Daniel Shiffman
// <http://www.shiffman.net>

// A Thread using receiving UDP to receive images

import java.awt.image.*; 
import javax.imageio.*;

PImage video1;
PImage video2;

ReceiverThread thread1;
ReceiverThread thread2;

void setup() {
  size(800,300);
  video1 = createImage(176, 144,RGB);
  video2 = createImage(176, 144,RGB);  
  thread1 = new ReceiverThread(video1.width,video1.height,5001);
  thread2 = new ReceiverThread(video2.width,video2.height,5000);
  thread1.start();
  thread2.start();
}

 void draw() {
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



