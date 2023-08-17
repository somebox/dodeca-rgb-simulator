import peasy.*;
PeasyCam cam;
PMatrix3D world;


/*
 I need to render a 3d dodecohedron using processing language.
 I am using processing 3d renderer and basic primatives, vertexes and translations.
 
 A pentagon is a 3d shape with 12 sides, and each side is a pentagon made up of 5 equal lines.
 The top and bottom of the pentagon are parallel. In a regular dodecaheron, each side is connected to
 five other pentagons, and the center of all 12 sides are exactly the same distance (radius) from the center
 of the shape.
 
 I would like to have a function which takes two parameters:
 radius and a side number (0-11), and draws the five points of the given pentagon as a closed shape
 at the correct location and angle. By calling this function 12 times, a full dodecoheron should be rendered.
 the code should use the processing language (documentation available at processing.org),
 use the P3D renderer, and can use draw methods like beginShape(), endShape(), vertex(), rotateX(),
 pushMatrix(), and so forth.
 
 */

float xv, yv, zv = 0;
float hemi_off = 0;
float radius = 200;
int led_counter = 0;
boolean first_pass = true;

class LedPoint {
  public int index;
  public float x, y, z;
  public float a, c;
  public int r, g, b;

  public LedPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.index = led_counter++;
    print(index+": ");
    print(x, y, z, "\n");
  }
}

int NUM_LEDS = 26*12;
ArrayList<LedPoint> leds = new ArrayList();
// the rotations of each pentagon face, 0-4 (60 degree increments)
int side_rotation[] = {0,1,0,0,0,0,0,0,0,0,0,0,0};

void drawLED(int led_num) {
  pushMatrix();
  translate(0, 0, 5);
  box(20, 20, 10);
  textSize(20);
  text(led_num, 0, -25, 22);  // Specify a z-axis value

  if (first_pass) {
    float x = modelX(0, 0, 0);
    float y = modelY(0, 0, 0);
    float z = modelZ(0, 0, 0);
    leds.add(new LedPoint(x, y, z));
  }

  popMatrix();
}

// Function to draw a pentagon at the specified side number
void drawPentagon(float radius, int sideNumber) {
  pushMatrix();
  float rot_offset = side_rotation[sideNumber]*TWO_PI/5;

  if (sideNumber == 0) {
    rotateZ(radians(-18)+rot_offset);
  } else if (sideNumber > 0 && sideNumber < 6) {
    rotateZ(rot_offset-TWO_PI/5*(sideNumber)-radians(zv));
    rotateX(radians(xv));
    rotateY(radians(yv));
  } else if (sideNumber >= 6 && sideNumber < 11) {
    rotateZ(rot_offset-TWO_PI/5*(sideNumber)+radians(zv));
    rotateX(PI - radians(xv));
  } else if (sideNumber == 11) {
    rotateX(radians(180));
    rotateZ(radians(18)+rot_offset);
  }

  translate(0, 0, radius*1.30+hemi_off); // Center the shape in the canvas
  textSize(310);
  fill(130);
  textMode(SHAPE);
  textAlign(CENTER, CENTER);
  text(sideNumber, 0, -50, 2);  // Specify a z-axis value

  beginShape();
  fill(100);
  float z = 0; // Distance between the center and side plane
  float angle = TWO_PI / 5;
  if (sideNumber >= 6 && sideNumber < 11) {
    rotateZ(radians(-zv));
  } else {
    rotateZ(radians(zv));
  }
  for (int i = 0; i < 5; i++) {
    // Calculate the x, y, z coordinates of each point on the pentagon
    float x = radius * cos(angle * i);
    float y = radius * sin(angle * i);
    vertex(x, y, z);
  }
  endShape(CLOSE);

  // draw LEDs
  fill(255);
  // center LED
  drawLED(1);
  // inner ring of 10 LEDs
  for (int i=0; i<10; i++) {
    pushMatrix();
    float rot = PI*2/10;
    rotateZ(-rot*i+rot);
    translate(0, radius/2.5, 0);
    drawLED(2+i);
    popMatrix();
  }
  // outer pentagon of 15 LEDs
  for (int i=0; i<5; i++) {
    pushMatrix();
    rotateZ(-PI*2/5*i+radians(18));
    translate(0, radius*0.65, 0);
    for (int j=0; j<3; j++) {
      pushMatrix();
      translate(-60+j*60, 0, 0);
      drawLED(12+i*3+j);
      popMatrix();
    }
    popMatrix();
  }

  popMatrix();
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case (UP):
      zv++;
      break;
      case (DOWN):
      zv--;
      break;
      case (LEFT):
      yv--;
      break;
      case (RIGHT):
      yv++;
      break;
    }
  } else {
    switch (key) {
    case ',':
      xv-= 0.1;
      break;
    case '.':
      xv+= 0.1;
      break;
    }
  }
}

void exportJSON() {
  JSONArray doc = new JSONArray();
  int i = 0;
  for (LedPoint led : leds) {
    JSONObject pos = new JSONObject();
    pos.setInt("id", led.index);
    pos.setFloat("x", led.x);
    pos.setFloat("y", led.y);
    pos.setFloat("z", led.z);
    doc.setJSONObject(i, pos);
    i++;
  }
  saveJSONArray(doc, "data/points.json");
}

void exportCArray() {
  int i = 0;
  // open a text file in data dir
  PrintWriter output = createWriter("data/points.h");
  for (LedPoint led : leds) {
    // write each point to the file as a C array
    // XYZ points[0] = {0, 0, 0};
    output.println("XYZ("+led.x+", "+led.y+", "+led.z+"),");
    i++;
  }
  output.flush(); // Write the remaining data
  output.close(); // Finish the file 
}


static float ci = 0;
static int target = 80;
void draw_points() {
  JSONArray doc;
  doc = loadJSONArray("data/points.json");
  for (int i=0; i<doc.size(); i++) {
    JSONObject p = doc.getJSONObject(i);
    float x = p.getFloat("x");
    float y = p.getFloat("y");
    float z = p.getFloat("z");
    color c = color(80, 80, 80);
    float d = (ci-z);
    if (abs(d) < target) {
      float off = target - abs(d);
      c = color(target+off*2, target+off*2, target);
    }
    ci = (ci+0.005);
    if (ci > 350) ci = -350;

    fill(c);
    pushMatrix();
    translate(x, y, z);
    box(20);
    popMatrix();
  }
}

void draw_model() {
  pushMatrix();
  // Draw the dodecahedron
  for (int i = 0; i < 12; i++) {
    drawPentagon(radius, i);
  }

  // this.setMatrix(world);
  cam.beginHUD();
  textSize(20);
  textAlign(LEFT, TOP);
  text("xv: "+xv, 40, 30);
  text("yv: "+yv, 40, 50);
  text("zv: "+zv, 40, 70);
  text("hemi_off: "+hemi_off, 40, 110);
  cam.endHUD();

  popMatrix();

  if (first_pass) {
    // exportJSON();
    exportCArray();
    first_pass = false;
  }
}


void setup() {
  //fullScreen(P3D);
  size(800, 800, P3D);
  world = getMatrix(world);
  cam = new PeasyCam(this, 900);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1000);
  xv = 63.4;
  zv = -18;
  hemi_off = 2;

}

void draw() {
  background(0);
  lights();
  directionalLight(255, 255, 255, 150, 150, 0);

  //draw_points();
  draw_model();
}
