float mr = 0.01;

class Vehicle {
  PVector acceleration;
  PVector velocity;
  PVector position;
  float r;
  float maxspeed;
  float maxforce;
  
  float health;

  float[] dna;

  Vehicle(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, -2);
    position = new PVector(x, y);
    r = 4;
    maxspeed = 5;
    maxforce = 0.5;
    
    health = 1;
    
    dna = new float[4];
    // Food weight
    dna[0] = random(-2, 2);
    // Poison weight
    dna[1] = random(-2, 2);
    // Food perception
    dna[2] = random(0, 100);
    // Poison Perception
    dna[3] = random(0, 100);
  }
  
  Vehicle(float x, float y, float[] dna_) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, -2);
    position = new PVector(x, y);
    r = 4;
    maxspeed = 5;
    maxforce = 0.5;
    
    health = 1;
    
    dna = new float[4];
    // Mutation
    dna[0] = dna_[0];
    if (random(1) < mr) {
      dna[0] += random(-0.1, 0.1);
    }
    dna[1] = dna_[1];
    if (random(1) < mr) {
      dna[1] += random(-0.1, 0.1);
    }
    dna[2] = dna_[2];
    if (random(1) < mr) {
      dna[2] += random(-10, 10);
    }
    dna[3] = dna_[3];
    if (random(1) < mr) {
      dna[3] += random(-10, 10);
    }
  }

  // Method to update location
  void update() {
    
    health -= 0.005;
    
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void behaviors(ArrayList<PVector> good, ArrayList<PVector> bad) {
    PVector steerG = eat(good, 0.2, dna[2]);
    PVector steerB = eat(bad, -1, dna[3]);
    
    steerG.mult(dna[0]);
    steerB.mult(dna[1]);
    
    applyForce(steerG);
    applyForce(steerB);
  }
  
  Vehicle clone() {
    if (random(1) < 0.002) {
      return new Vehicle(position.x, position.y, dna);
    } else {
      return null;
    }
  }
  
  PVector eat(ArrayList<PVector> list, float nutrition, float perception) {
    float record = 10000000;
    PVector closest = null;
    for (int i = list.size()-1; i >= 0; i--) {
      PVector j = list.get(i);
      float d = position.dist(j);
      
      if (d < maxspeed) {
        list.remove(i);
        health += nutrition;
      } else {
        if (d < record && d < perception) {
          record = d;
          closest = j;
        }
      }
    }
    
    // This is the moment of eating!
    if (closest != null) {
      return seek(closest);
    }
    
    return new PVector(0, 0);
    
    
    
    
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED - VELOCITY
  PVector seek(PVector target) {

    PVector desired = PVector.sub(target, position);

    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired - velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); // Limit to maximum steering force

    return steer;
    //applyForce(steer);
  }
  
  boolean dead() {
    return (health < 0);
  }
  
  void display() {
    // Draw a triangle rotated in direction of velocity
    float angle = velocity.heading() + PI / 2;
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    
    if (debug) {
      strokeWeight(3);
      stroke(0, 255, 0);
      noFill();
      line(0, 0, 0, -dna[0] * 20);
      strokeWeight(2);
      ellipse(0, 0, dna[2] * 2, dna[2] * 2);
      stroke(255, 0, 0);
      line(0, 0, 0, -dna[1] * 20);
      ellipse(0, 0, dna[3] * 2, dna[3] * 2);
    }
    
    color gr = color(0, 255, 0);
    color rd = color(255, 0, 0);
    color col = lerpColor(rd, gr, health);
    
    fill(col);
    stroke(col);
    strokeWeight(1);
    beginShape();
    vertex(0, -r * 2);
    vertex(-r, r * 2);
    vertex(r, r * 2);
    endShape(CLOSE);
    
    
    
    popMatrix();
  }
  
  void boundaries() {
    float d = 25;
    
    PVector desired = null;

    if (position.x < d) {
      desired = new PVector(maxspeed, velocity.y);
    } else if (position.x > width - d) {
      desired = new PVector(-maxspeed, velocity.y);
    }

    if (position.y < d) {
      desired = new PVector(velocity.x, maxspeed);
    } else if (position.y > height - d) {
      desired = new PVector(velocity.x, -maxspeed);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }
}