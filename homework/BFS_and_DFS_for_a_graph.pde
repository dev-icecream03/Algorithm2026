class Node {
  int id;
  float x, y;
  IntList neighbors;
  int visitOrder = -1; // -1 means unvisited
  
  Node(int id, float x, float y) {
    this.id = id;
    this.x = x;
    this.y = y;
    neighbors = new IntList();
  }
  
  void addNeighbor(int nId) {
    if (!neighbors.hasValue(nId)) {
      neighbors.append(nId);
    }
  }
}

ArrayList<Node> nodes;
IntList traversalOrder;
int animIndex = -1;
int animTimer = 0;
int animInterval = 30; // Animation speed (lower = faster, higher = slower)
String searchType = "None";

void setup() {
  size(700, 600);
  textSize(15);
  generateRandomGraph(); // Generate graph with non-overlapping layout on startup
}

void draw() {
  background(30); // Dark background
  
  // Animation timer based on animInterval speed
  if (animIndex >= 0) {
    animTimer++;
    if (animTimer > animInterval) {
      animTimer = 0;
      animIndex++;
      if (animIndex >= traversalOrder.size()) {
        animIndex = -1; // End of animation
      }
    }
  }
  
  // 1. Draw edges first
  stroke(100);
  strokeWeight(2);
  for (Node n : nodes) {
    for (int i = 0; i < n.neighbors.size(); i++) {
      int nextId = n.neighbors.get(i);
      Node nextNode = getNode(nextId);
      if (n.id < nextNode.id) { // Prevent double drawing
        line(n.x, n.y, nextNode.x, nextNode.y);
      }
    }
  }
  
  // 2. Update node visit states based on current animation step
  for (Node n : nodes) {
    n.visitOrder = -1;
  }
  if (animIndex >= 0) {
    for (int i = 0; i <= animIndex && i < traversalOrder.size(); i++) {
      int nId = traversalOrder.get(i);
      getNode(nId).visitOrder = i + 1; // Record visit sequence number
    }
  }
  
  // 3. Draw nodes (circles)
  for (Node n : nodes) {
    // Color coding: Current exploring (Red), Visited (Green), Default (Blue)
    if (animIndex >= 0 && n.visitOrder != -1) {
      if (n.visitOrder == animIndex + 1) {
        fill(255, 90, 90); // Current active node
      } else {
        fill(90, 220, 90); // Visited node
      }
    } else {
      fill(80, 140, 255); // Ready node
    }
    
    noStroke();
    ellipse(n.x, n.y, 55, 55);
    
    // Display node ID and visit order
    fill(255);
    textAlign(CENTER, CENTER);
    String label = "N" + n.id;
    if (n.visitOrder != -1) {
      label += "\n(" + n.visitOrder + ")";
    }
    text(label, n.x, n.y);
  }
  
  // Top UI instructions
  fill(255);
  textAlign(LEFT, TOP);
  text("[ Controls ]", 20, 20);
  text("Press 'R' : Generate New Random Graph", 20, 45);
  text("Press '1' : Run BFS | Press '2' : Run DFS", 20, 70);
  text("Press 'UP' / 'DOWN' : Adjust Speed (Interval: " + animInterval + ")", 20, 95);
  text("Current Mode: " + searchType, 20, 130);
}

// Find node object by ID
Node getNode(int id) {
  for (Node n : nodes) {
    if (n.id == id) return n;
  }
  return null;
}

// Generate random graph with Force-Directed layout to minimize edge crossings
void generateRandomGraph() {
  nodes = new ArrayList<Node>();
  animIndex = -1;
  searchType = "None (Ready)";
  
  int numNodes = 7; // Number of nodes
  
  // Step 1: Initial random placement
  for (int i = 0; i < numNodes; i++) {
    float x = random(120, width - 120);
    float y = random(180, height - 100);
    nodes.add(new Node(i, x, y));
  }
  
  // Step 2: Build a spanning tree to guarantee connectivity
  for (int i = 1; i < numNodes; i++) {
    int prev = int(random(0, i));
    nodes.get(i).addNeighbor(prev);
    nodes.get(prev).addNeighbor(i);
  }
  
  // Add some extra random edges (20% probability)
  for (int i = 0; i < numNodes; i++) {
    for (int j = i + 1; j < numNodes; j++) {
      if (random(1) < 0.2) {
        nodes.get(i).addNeighbor(j);
        nodes.get(j).addNeighbor(i);
      }
    }
  }
  
  // Step 3: Force-Directed Layout Simulation (spreads nodes & reduces crossings)
  for (int iter = 0; iter < 120; iter++) {
    for (int i = 0; i < numNodes; i++) {
      Node n1 = nodes.get(i);
      float fx = 0, fy = 0;
      
      // Repulsion force between all nodes (prevents overlap)
      for (int j = 0; j < numNodes; j++) {
        if (i == j) continue;
        Node n2 = nodes.get(j);
        float dx = n1.x - n2.x;
        float dy = n1.y - n2.y;
        float dist = sqrt(dx*dx + dy*dy);
        if (dist < 1) dist = 1;
        if (dist < 140) {
          fx += (dx / dist) * (140 - dist) * 0.15;
          fy += (dy / dist) * (140 - dist) * 0.15;
        }
      }
      
      // Attraction force along connected edges (keeps neighbors close)
      for (int j = 0; j < n1.neighbors.size(); j++) {
        Node n2 = getNode(n1.neighbors.get(j));
        float dx = n2.x - n1.x;
        float dy = n2.y - n1.y;
        fx += dx * 0.05;
        fy += dy * 0.05;
      }
      
      n1.x += fx;
      n1.y += fy;
      
      // Keep nodes inside canvas boundaries
      n1.x = constrain(n1.x, 80, width - 80);
      n1.y = constrain(n1.y, 160, height - 60);
    }
  }
  
  for (Node n : nodes) {
    n.neighbors.sort();
  }
}

// Handle keyboard inputs
void keyPressed() {
  if (key == 'r' || key == 'R') {
    generateRandomGraph();
  } else if (key == '1') {
    runBFS(0); // Start BFS from node 0
  } else if (key == '2') {
    runDFS(0); // Start DFS from node 0
  } else if (keyCode == UP) {
    animInterval = max(5, animInterval - 5); // Speed up (minimum interval 5 frames)
  } else if (keyCode == DOWN) {
    animInterval = min(100, animInterval + 5); // Slow down (maximum interval 100 frames)
  }
}

// BFS algorithm execution
void runBFS(int startId) {
  searchType = "BFS (Breadth-First Search)";
  traversalOrder = new IntList();
  
  boolean[] visited = new boolean[nodes.size()];
  IntList queue = new IntList();
  
  queue.append(startId);
  visited[startId] = true;
  
  while (queue.size() > 0) {
    int curr = queue.get(0);
    queue.remove(0);
    traversalOrder.append(curr);
    
    Node n = getNode(curr);
    for (int i = 0; i < n.neighbors.size(); i++) {
      int next = n.neighbors.get(i);
      if (!visited[next]) {
        visited[next] = true;
        queue.append(next);
      }
    }
  }
  animIndex = 0;
  animTimer = 0;
}

// DFS algorithm execution
void runDFS(int startId) {
  searchType = "DFS (Depth-First Search)";
  traversalOrder = new IntList();
  
  boolean[] visited = new boolean[nodes.size()];
  IntList stack = new IntList();
  
  stack.append(startId);
  
  while (stack.size() > 0) {
    int curr = stack.get(stack.size() - 1);
    stack.remove(stack.size() - 1);
    
    if (!visited[curr]) {
      visited[curr] = true;
      traversalOrder.append(curr);
      
      Node n = getNode(curr);
      for (int i = n.neighbors.size() - 1; i >= 0; i--) {
        int next = n.neighbors.get(i);
        if (!visited[next]) {
          stack.append(next);
        }
      }
    }
  }
  animIndex = 0;
  animTimer = 0;
}
