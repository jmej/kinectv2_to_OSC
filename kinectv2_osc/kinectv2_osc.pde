/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 Modified by Jesse Mejia to include OSC output 
 and to ONLY display and emit osc for the first skelly via the OSCP5 library
 http://anestheticaudio.com/
 
 KinectPV2, Kinect for Windows v2 library for processing

 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import oscP5.*;
import netP5.*;

KinectPV2 kinect;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(1920, 1080, P3D);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. Set to 127.0.0.1 by default to send to another application
   * on the same machine.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    if (i == 0) {//dumb thing to ignore all but the first skelly
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
        if (skeleton.isTracked()) {
          KJoint[] joints = skeleton.getJoints();
    
          color col  = skeleton.getIndexColor();
          fill(col);
          stroke(col);
          drawBody(joints);
    
          //draw different color for each hand state
          drawHandState(joints[KinectPV2.JointType_HandRight]);
          drawHandState(joints[KinectPV2.JointType_HandLeft]);
        }
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck, "head");
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder, "neck");
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, "spineshoulder");
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase, "spinemid");
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight, "spineshoulder");
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft, "spineshoulder");
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight, "spinebase");
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft, "spinebase");

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight, "rightshoulder");
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight, "rightelbow");
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight, "rightwrist");
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight, "righthand");
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight, "rightwrist");

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft, "leftshoulder");
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft, "leftelbow");
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft, "leftwrist");
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft, "lefthand");
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft, "leftwrist");

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight, "righthip");
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight, "rightknee");
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight, "rightankle");

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft, "leftknee");
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft, "leftankle");
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft, "leftfoot");

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
  ellipse(0, 0, 25, 25);
  popMatrix();
}
// usage: drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight, "righthand");
//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2, String jointName) {
  OscMessage myMessage = new OscMessage("/"+jointName);
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  //scale everything to 0-127 / midi range
  float scaledX = map(joints[jointType1].getX(), 0, width, 0, 127);
  float scaledY = map(joints[jointType1].getY(), 0, height, 127, 0);
  float scaledZ = map(joints[jointType1].getZ(), 0, height, 0, 127); //i don't know what the Z axis range should be, doesn't seem to be reporting anything
  myMessage.add(new float[] {scaledX,scaledY, scaledZ});
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  oscP5.send(myMessage, myRemoteLocation); 
  delay(5);
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}