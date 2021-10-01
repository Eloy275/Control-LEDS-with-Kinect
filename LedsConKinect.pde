import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

// crear el objeto arduino

Arduino arduino;

float verde, rojo, azul;
float manoDerechaY, manoDerechaX, manoIzquierdaX, manoIzquierdaY;
color colorMano; 

void setup() {
  rojo=0; //Pin 11
  verde=0; //Pin 10
  azul=0; //Pin 09

  //println(Arduino.list()); // Puerto 2
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  size(1920, 1080, P3D);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
}

void draw() {
  arduino.analogWrite(11, int(rojo));
  arduino.analogWrite(10, int(verde));
  arduino.analogWrite(9, int(azul));

  background(0);

  strokeWeight(30);
  stroke(255, 0, 0);
  rect(0, 1085, 639, 1080);

  strokeWeight(30);
  stroke(0, 255, 0); 
  rect(642, 1085, 638, 1080);

  strokeWeight(30);
  stroke(0, 0, 255);
  rect(1284, 1085, 1917, 1080);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(0, 0, 0, 25);
      stroke(0, 0, 0, 25);
      //drawBody(joints);
      drawJoint(joints, KinectPV2.JointType_HandTipLeft);
      drawJoint(joints, KinectPV2.JointType_HandTipRight);
      manoDerechaY = joints[KinectPV2.JointType_HandTipRight].getY();
      manoDerechaX = joints[KinectPV2.JointType_HandTipRight].getX();
      manoIzquierdaY = joints[KinectPV2.JointType_HandTipLeft].getY();
      manoIzquierdaX = joints[KinectPV2.JointType_HandTipLeft].getX();

      //println(manoDerechaY);
      //println(joints[KinectPV2.JointType_HandTipRight].getZ());
      // println(joints[KinectPV2.JointType_HandTipLeft].getZ());
      //draw different color for each hand state
      if (manoDerechaX > 0 && manoDerechaX < 640) {
        colorMano = color(255, 0, 0);
      }
      if (manoDerechaX > 640 && manoDerechaX < 1280) {
        colorMano = color(0, 255, 0);
      }
      if (manoDerechaX > 1280 && manoDerechaX < 1920) { 
        colorMano = color(0, 0, 255);
      }
      drawHandState(joints[KinectPV2.JointType_HandRight]);

      if (manoIzquierdaX > 0 && manoIzquierdaX < 640) {
        colorMano = color(255, 0, 0);
      }
      if (manoIzquierdaX > 640 && manoIzquierdaX < 1280) {
        colorMano = color(0, 255, 0);
      }
      if (manoIzquierdaX > 1280 && manoIzquierdaX < 1920) { 
        colorMano = color(0, 0, 255);
      }
      drawHandState(joints[KinectPV2.JointType_HandLeft]);


      if (joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Closed) {
        if (manoDerechaX > 0 && manoDerechaX < 640 && manoDerechaY > 150) { 
          rojo=map(manoDerechaY, 0, 1080, 0, 255);
          colorMano = color(255, 0, 0);
        }
        if (manoDerechaX > 0 && manoDerechaX < 640 && manoDerechaY < 150) { 
          rojo=map(manoDerechaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
        if (manoDerechaX > 640 && manoDerechaX < 1280 && manoDerechaY > 150) { 
          verde=map(manoDerechaY, 0, 1080, 0, 255);
          colorMano = color(0, 255, 0);
        }
        if (manoDerechaX > 640 && manoDerechaX < 1280 && manoDerechaY < 150) { 
          verde=map(manoDerechaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
        if (manoDerechaX > 1280 && manoDerechaX < 1920 && manoDerechaY > 150) { 
          azul=map(manoDerechaY, 0, 1080, 0, 255);
          colorMano = color(0, 0, 255);
        }
        if (manoDerechaX > 1280 && manoDerechaX < 1920 && manoDerechaY < 150) { 
          azul=map(manoDerechaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
      }
      if (joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Closed) {
        if (manoIzquierdaX > 0 && manoIzquierdaX < 640) { 
          rojo=map(manoIzquierdaY, 0, 1080, 0, 255);
          colorMano = color(255, 0, 0);
        }
        if (manoIzquierdaX > 0 && manoIzquierdaX < 640 && manoIzquierdaY < 150) { 
          rojo=map(manoIzquierdaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
        if (manoIzquierdaX > 640 && manoIzquierdaX < 1280) { 
          verde=map(manoIzquierdaY, 0, 1080, 0, 255);
          colorMano = color(0, 255, 0);
        }
        if (manoIzquierdaX > 640 && manoIzquierdaX < 1280 && manoIzquierdaY < 150) { 
          verde=map(manoIzquierdaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
        if (manoIzquierdaX > 1280 && manoIzquierdaX < 1920) { 
          azul=map(manoIzquierdaY, 0, 1080, 0, 255);
          colorMano = color(0, 0, 255);
        }
        if (manoIzquierdaX > 1280 && manoIzquierdaX < 1920 && manoIzquierdaY < 150) { 
          azul=map(manoIzquierdaY, 0, 150, 0, 0);
          colorMano = color(255, 255, 255, 25);
        }
      }
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}


//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  // ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  // ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state

void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 90, 90);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HancolorManodState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(colorMano, 50);
    break;
  case KinectPV2.HandState_Closed:
    fill(colorMano, 100);
    break;

  case KinectPV2.HandState_Lasso:
    fill(0, 0, 0, 0);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(0, 0, 0, 50);
    break;
  }
}
