// Based on code from Dan Shiffman
// Nature of Code

ArrayList<Ant> ants;
PImage picnic;

void setup() {
  size(800, 800);
  ants = new ArrayList<Ant>();
  picnic = loadImage("picnictablecloth.jpg");
  for (int i = 0; i <50; i++) {
    ants.add(new Ant(random(width), random(height)));
  }
}

void draw() {
  background(255);
  image(picnic, 0, 0);

  for (int i=ants.size()-1; i>=0; i--) {
    Ant a = ants.get(i);
    a.separate(ants);  // Path following and separation are worked on in this function
    a.update();  // Call the generic run method (update, borders, display, etc.)
    a.display();  //a.borders();
    a.checkEdges();
  }
}

