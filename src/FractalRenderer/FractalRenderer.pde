double xmin = -2.5;
double ymin = -2;
double zoom = 4;
double downX, downY, startX, startY, startWH;
int maxIterations = 100;
boolean shiftPressed = false;

void setup() {
  size(800, 800);
  colorMode(HSB, 255);
  loadPixels();
  cTest();
  textSize(30);
}



int m = 0;

void draw() {
  if (keyPressed && key == ' ') { //DISCO TIME!!!!
    m+=10;
  }
  double xmax = xmin + zoom;
  double ymax = ymin + zoom;

  // Calculate amount we increment x,y for each pixel
  double dx = (xmax-xmin) / width;
  double dy = (ymax-ymin) / height;

  double y = ymin;
  for (int j = 0; j < height; j++) {
    double x = xmin;
    for (int i = 0; i < width; i++) {
      Complex z = complex(0, 0);
      Complex c = complex(x, y);
      int n = 0;
      while (n < maxIterations) {
        z = cMultiply(z, z);
        z.add(c);
        if(z.getMagnitude()>12) break; //z.r+z.i>16 //z.getMagnitude()>99999999999L
        n++;
      }
      pixels[i+j*width] = (n==maxIterations) ? color(0) : color(255); //(n*16+m) % 255, 255, 255
      x += dx;
    }
    y += dy;
  }
  updatePixels();
  fill(255);
  text((float)round(frameRate*10)/10 + " fps    zoom: " + round((float)(1/zoom)), 0, textAscent());
  
  
  ////this stuff was supposed was supposed to visualize the trajectory of the value at the mouse position
  
  //Complex z = complex(0, 0); 
  //Complex c = complex(xmin+mouseX*zoom , ymin+mouseY*zoom);
  //int n = 0;
  //while (n < maxIterations) {
  //  z = cMultiply(z, z);
  //  z.add(c);
  //  ellipse((float)(z.r*zoom-xmin), (float)(z.i*zoom-ymin), 10, 10);
  //  if(z.getMagnitude()>99) break;
  //  n++;
  //}
}

void mousePressed() {
  downX=mouseX;
  downY=mouseY;
  startX=xmin;
  startY=ymin;
  startWH=zoom;
}

void mouseDragged() {
  double deltaX=(mouseX-downX)/width;
  double deltaY=(mouseY-downY)/height;

  if (!keyPressed || keyCode != SHIFT) { //i don't like this line
    xmin = startX-deltaX*zoom;
    ymin = startY-deltaY*zoom;
  } else {
    if (zoom>10) zoom=10;
    if (deltaX>1) deltaX=1;
    zoom = startWH-deltaX*zoom;
    xmin = startX+deltaX*zoom/2;
    ymin = startY+deltaX*zoom/2;
  }
}
