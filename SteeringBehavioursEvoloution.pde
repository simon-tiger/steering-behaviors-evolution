ArrayList<Vehicle> vehicles;
ArrayList<PVector> food;
ArrayList<PVector> poison;

boolean debug;

void setup() {
  size(640, 360);
  vehicles = new ArrayList<Vehicle>();
  food = new ArrayList<PVector>();
  poison = new ArrayList<PVector>();
  for (int i = 0; i < 50; i++) {
    float x = random(width);
    float y = random(height);
    vehicles.add(new Vehicle(x, y));
  }
  
  for (int i = 0; i < 40; i++) {
    float x = random(width);
    float y = random(height);
    food.add(new PVector(x, y));
  }
  for (int i = 0; i < 20; i++) {
    float x = random(width);
    float y = random(height);
    poison.add(new PVector(x, y));
  }
  
  
}

void keyPressed() {
  if (key == 'd') {
    debug = !debug;
  }
}

void mouseDragged() {
  vehicles.add(new Vehicle(mouseX, mouseY));
}

void draw() {
  background(51);
  
  if (random(1) < 0.1) {
    float x = random(width);
    float y = random(height);
    food.add(new PVector(x, y));
  }
  
  if (random(1) < 0.01) {
    float x = random(width);
    float y = random(height);
    poison.add(new PVector(x, y));
  }
  
  
  for (PVector f : food) {
    fill(0, 255, 0);
    noStroke();
    ellipse(f.x, f.y, 4, 4);
  }
  
  for (PVector p : poison) {
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 4, 4);
  }
  
  for (int i = vehicles.size()-1; i >= 0; i--) {
    Vehicle v = vehicles.get(i);
    v.boundaries();
    v.behaviors(food, poison);
    v.update();
    v.display();
    
    Vehicle newVehicle = v.clone();
    if (newVehicle != null) {
      vehicles.add(newVehicle);
    }
    
    if (v.dead()) {
      float x = v.position.x;
      float y = v.position.y;
      food.add(new PVector(x, y));
      vehicles.remove(i);
    }
    
  }
}