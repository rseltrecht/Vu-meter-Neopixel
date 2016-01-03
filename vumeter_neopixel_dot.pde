import processing.sound.*;

OPC opc;
PImage dot;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

float maxVolume = 0;
// float kConstAmp = 2000; // For TEDxRennes
float kConstAmp = 2000;

Amplitude amp;
color green1, red1;

int Y_AXIS = 1;
int X_AXIS = 2;

void setup()
{
  size(1920, 980);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  // Load a sample image
  dot = loadImage("color-dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 64-LED strip to the center of the window
  // opc.ledStrip(0, 60, width/2, height/2 -10 , width / 62.0, 0, false);
  // opc.ledStrip(60, 60, width/2, height/2 -10, width / 62.0, 0, false);
  
    // Set the location of several LEDs arranged in a grid. The first strip is
  // at 'angle', measured in radians clockwise from +X.
  // (x,y) is the center of the grid.
  // void ledGrid(int index, int stripLength, int numStrips, float x, float y, float ledSpacing, float stripSpacing, float angle, boolean zigzag)

  // opc.ledGrid(0, 64, 2,  width/2,  height/2, width / 66.0, width / 66.0, 0, false);
    opc.ledGrid(0, 64, 4,  width/2,  height/2, width / 66.0, width / 66.0, 0, false);

    
   // Define colors
  red1 = color(204, 0, 0);
  green1 = color(0, 204, 0);
  
  
}

void draw()
{
  background(0);

  // Draw the image, centered at the mouse location
  // float dotSize = width * 0.2;
  
  if ((amp.analyze() * kConstAmp) > maxVolume) 
  {
    maxVolume = amp.analyze() * kConstAmp;
  } 
  
  stroke(153);
  textSize(35);
  textAlign(CENTER, TOP);
  text("MAX APPLAUDIMETRE TEDX = " + int(maxVolume), width / 2, 60 );

  // image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
  // image(dot, amp.analyze()* 10000 , amp.analyze()* 10000, dotSize, dotSize);
  
  setGradient(0, height/4, int(amp.analyze() * kConstAmp), height / 2, green1, red1, X_AXIS);

  println(int(amp.analyze() * kConstAmp ));
  
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}