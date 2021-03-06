// Based on code by Dan Shiffman
// Nature of Code

class Ant {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float wandertheta;
  float keepAway;
  float maxforce;
  float maxspeed;
  PVector ellipse1;
  PVector ellipse2;
  PVector ellipse3;
  PVector ellipse4;
  int overlap;

  Ant(float x, float y) {

    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    wandertheta = 0;
    keepAway = 100;
    maxforce = 0.8;
    maxspeed = 6;
    ellipse1 = new PVector(25, 18);
    ellipse2 = new PVector(10, 8);
    ellipse3 = new PVector(15, 13);
    ellipse4 = new PVector(15, 15);
    overlap = 3;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void separate(ArrayList<Ant> ants) {
    float desiredseparation = keepAway;
    PVector sum = new PVector();
    int count = 0;

    for (Ant other : ants) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;
      }
    }

    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }

  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  /*
  void wander() {
   float wanderR = 25;
   float wanderD = 80;
   float change = 0.3;
   wandertheta += random(-change, change);
   PVector circleloc = velocity.get();
   circleloc.normalize();
   circleloc.mult(wanderD);
   circleloc.add(location);
   float h = velocity.heading2D();
   PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h), wanderR*sin(wandertheta+h));
   PVector target = PVector.add(circleloc, circleOffSet);
   seek(target);
   }*/

  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void display() {
    float theta = velocity.heading2D() + radians(180);
    float leg_move = sin(frameCount * velocity.x) * 2;
    float antenna_move = sin(frameCount * velocity.x)/1.5;
    ellipseMode(CENTER);
    noStroke();
    fill(0);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    ellipse(0, 0, ellipse1.x, ellipse1.y); //ellipse1 (butt)
    ellipse(-(ellipse1.x/2 + ellipse2.x/2)+overlap, 0, ellipse2.x, 
    ellipse2.y); //ellipse2
    ellipse(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap, 0, 
    ellipse3.x, ellipse3.y); //ellipse3
    ellipse(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap, 0, ellipse4.x, ellipse4.y); //ellipse4 (head)
    noFill();
    stroke(0);
    strokeWeight(2);

    // antenna 1
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap-10, -10+antenna_move*2);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap-20, -12+antenna_move*2);
    endShape();

    // antenna 2
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap-10, 10+antenna_move*2);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x +
      ellipse3.x/2)+3*overlap-20, 12+antenna_move*2);
    endShape();

    // leg 1
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap-8 +leg_move, -10);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap-18 +leg_move, -15);
    endShape();

    // leg 2
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap-8-leg_move, 10);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap-18-leg_move, 15);
    endShape();

    // leg 3
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap+1-leg_move, -10);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap+6-leg_move, -20);
    endShape();

    // leg 4
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap+1+leg_move, 10);
    vertex(-(ellipse1.x/2 + ellipse2.x + ellipse3.x/2)+2*overlap+6+leg_move, 20);
    endShape();

    // leg 5
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x/2)-2, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x/2)+2+leg_move, -10);
    vertex(-(ellipse1.x/2 + ellipse2.x/2)+15+leg_move, -23);
    endShape();

    // leg 6
    beginShape();
    vertex(-(ellipse1.x/2 + ellipse2.x/2)-2, 0);
    vertex(-(ellipse1.x/2 + ellipse2.x/2)+2-leg_move, 10);
    vertex(-(ellipse1.x/2 + ellipse2.x/2)+15-leg_move, 23);
    endShape();
    
    popMatrix();
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } 
    else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }

    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
    else if (location.y < 0) {
      velocity.y *= -1;
      location.y = 0;
    }
  }
}

