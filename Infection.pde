ArrayList<Person> population = new ArrayList<Person>();
IntList healthy = new IntList();
IntList infected = new IntList();
IntList immune = new IntList();
IntList dead = new IntList();

float moveSpeed = 1;
float angleSpeed = 0.5;
float infectionRadius = 30;
float infectionChance = 0.01;
float minImmunizationTime = 200;
float immunizationIncrease = 0.01;
float deathChance = 0.0025;

int incubationTime = 50;

float avoidingDistance = 50;
float avoidingSpeed = 0.5;
float attractionSpeed = 1;

int diagramSize = 1500;

void setup() {
  fullScreen(0);
  for (int i = 0; i < 750; i++) {
    population.add(new Person(new PVector(random(width), random(float(height)*(0.6)))));
  }
}

void draw() {
  //println(frameRate);
  background(0);
  healthy.append(0);
  infected.append(0);
  immune.append(0);
  dead.append(0);
  for (int i = 0; i < population.size(); i++) {
    population.get(i).update();
    population.get(i).show();
    if (population.get(i).state == State.HEALTHY) {
      healthy.add(healthy.size()-1, 1);
    } else if (population.get(i).state == State.INFECTED) {
      infected.add(infected.size()-1, 1);
    } else if (population.get(i).state == State.IMMUNE) {
      immune.add(immune.size()-1, 1);
    } else if (population.get(i).state == State.DEAD) {
      dead.add(dead.size()-1, 1);
    }
  }
  if (healthy.size() > diagramSize) {
    healthy.remove(0);
    infected.remove(0);
    immune.remove(0);
    dead.remove(0);
  }
  noFill();
  strokeWeight(2);
  stroke(0, 255, 0);
  beginShape();
  for (int i = 0; i < healthy.size(); i++) {
    vertex(map(i, 0, healthy.size()-1, 0, width), map(healthy.get(i), 0, population.size(), height, height*0.6));
  }
  endShape();
  stroke(255, 0, 0);
  beginShape();
  for (int i = 0; i < infected.size(); i++) {
    vertex(map(i, 0, infected.size()-1, 0, width), map(infected.get(i), 0, population.size(), height, height*0.6));
  }
  endShape();
  stroke(0, 0, 255);
  beginShape();
  for (int i = 0; i < immune.size(); i++) {
    vertex(map(i, 0, immune.size()-1, 0, width), map(immune.get(i), 0, population.size(), height, height*0.6));
  }
  endShape();
  stroke(100);
  beginShape();
  for (int i = 0; i < dead.size(); i++) {
    vertex(map(i, 0, dead.size()-1, 0, width), map(dead.get(i), 0, population.size(), height, height*0.6));
  }
  endShape();
  textSize(20);
  textAlign(LEFT, TOP);
  fill(0, 255, 0);
  text(healthy.get(healthy.size()-1), 0, height*0.6);
  fill(255, 0, 0);
  text(infected.get(infected.size()-1), 0, height*0.6+20);
  fill(0, 0, 255);
  text(immune.get(immune.size()-1), 0, height*0.6+40);
  fill(100);
  text(dead.get(dead.size()-1), 0, height*0.6+60);
}

void mousePressed() {
  for (int i = 0; i < population.size(); i++) {
    if (dist(population.get(i).pos.x, population.get(i).pos.y, mouseX, mouseY) <= 10) {
      population.get(i).state = State.INFECTED;
      population.get(i).infectionTime = frameCount;
    }
  }
}
