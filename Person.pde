class Person {
  PVector pos;
  float r = random(TWO_PI);
  State state = State.HEALTHY;
  int infectionTime = 0;
  boolean grouper;
  boolean noticed = false;

  Person (PVector pos_) {
    pos = pos_.copy();
    if (random(1) > 0.5) {
      grouper = true;
    } else {
      grouper = false;
    }
  }

  void update() {
    if (state != State.DEAD) {
      r += random(-angleSpeed, angleSpeed);
      if (!noticed) {
        pos.add(PVector.fromAngle(r).setMag(moveSpeed));
      } else {
        pos.add(PVector.fromAngle(r).setMag(moveSpeed*0.25));
      }
      if (pos.x < 0) {
        pos.x += width;
      }
      if (pos.x > width) {
        pos.x -= width;
      }
      if (pos.y < 0) {
        pos.y += float(height)*0.6;
      }
      if (pos.y > float(height)*0.6) {
        pos.y -= float(height)*0.6;
      }
      PVector p = new PVector();
      int n = 0;
      for (int i = 0; i < population.size(); i++) {
        if ((this == population.get(i) || !population.get(i).noticed) && population.get(i).state != State.DEAD && dist(pos.x, pos.y, population.get(i).pos.x, population.get(i).pos.y) < avoidingDistance) {
          p.add(population.get(i).pos.copy());
          n ++;
        }
      }
      p.div(n);
      if (floor(frameCount/100)%2 == 0 && grouper && !noticed) {
        pos.add(p.sub(pos).setMag(attractionSpeed));
      } else {
        pos.add(pos.copy().sub(p).setMag(avoidingSpeed));
      }
      if (state == State.HEALTHY) {
        for (int i = 0; i < population.size(); i++) {
          if (population.get(i) != this && population.get(i).state == State.INFECTED && dist(population.get(i).pos.x, population.get(i).pos.y, pos.x, pos.y) < infectionRadius && random(1) > infectionChance) {
            state = State.INFECTED;
            infectionTime = frameCount;
            break;
          }
        }
      } else if (state == State.INFECTED) {
        if (frameCount-infectionTime > incubationTime) {
          noticed = true;
        }
        if (random(1) < ((frameCount-infectionTime)-minImmunizationTime)*immunizationIncrease) {
          state = State.IMMUNE;
          noticed = false;
        } else if (random(1) < deathChance) {
          state = State.DEAD;
          noticed = false;
        }
      }
    }
  }

  void show() {
    if (state == State.HEALTHY) {
      stroke(0, 255, 0);
    } else if (state == State.INFECTED) {
      if (noticed) {
        stroke(255, 0, 0);
      } else {
        stroke(100, 0, 0);
      }
    } else if (state == State.IMMUNE) {
      stroke(0, 0, 255);
    } else if (state == State.DEAD) {
      stroke(100);
    } else {
      println("Something whent very wrong");
      stroke(255);
    }
    strokeWeight(3);
    point(pos.x, pos.y);
  }
}

enum State {
  HEALTHY, 
    INFECTED, 
    IMMUNE, 
    DEAD
}
