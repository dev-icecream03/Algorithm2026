int  n=8; //<>//
int  xstep=1;
int  ystep=70;
int  radius=45;
int  mode=0;
int  traversal=0;
int  textcolor=0;
PFont font;

int treeMode = 0;

RBTree rbTree = new RBTree();
BTree actualBTree = new BTree(3);

void setup() {
  size(1200, 600);
  font = createFont("Agency FB", 16);
  textFont(font, 16);
  textAlign(LEFT, CENTER);
  stroke(192, 0, 0);
  newTree();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    int x = (int)(100. * mouseX / width);

    if (treeMode == 0) {
      if (rbTree.value == -1) {
        rbTree.insert(x);
      } else {
        rbTree.remove(rbTree.value);
      }
    } else {
      if (actualBTree.value == -1) {
        actualBTree.insert(x);
      } else {
        println("B-Tree deletion is not implemented in this visualizer.");
      }
    }
  }
}

void mouseReleased() {
  drawTree();
}

void mouseMoved() {
  if (treeMode == 0) {
    rbTree.findNode();
    if (rbTree.value != -1) {
      fill(92);
      ellipse(rbTree.x, rbTree.y, radius, radius);
      fill(0);
      text(rbTree.value, rbTree.x, rbTree.y);
    } else drawTree();
  } else {
    actualBTree.findNode();
    if (actualBTree.value != -1) {
      fill(92);
      rectMode(CENTER);
      rect(actualBTree.x, actualBTree.y, radius * 1.8, 30, 5);
      fill(255);
      textAlign(CENTER, CENTER);
      text(actualBTree.value, actualBTree.x, actualBTree.y);
    } else drawTree();
  }
}

void keyPressed() {
  if (key=='c') {
    background(200);
    if (treeMode == 0) rbTree.clear();
    else actualBTree.clear();
  } else if (key=='v' || key ==' ') {
    drawTree();
    if (treeMode == 0) rbTree.printTree();
    else actualBTree.printTree();
  } else if (key=='b') {
    newTree();
  } else if (key=='t') {
    traversal++;
    if (traversal==3) traversal=0;
    drawTree();
  } else if (key=='d') {
    if (textcolor==0) textcolor=1;
    else textcolor=0;
    drawTree();
  } else if (key=='m' || key=='M') {
    treeMode = (treeMode == 0) ? 1 : 0;
    newTree();
  }
}

void newTree() {
  if (treeMode == 0) {
    rbTree.clear();
    for (int i=0; i<n; i++) rbTree.insert((int)random(99));
  } else {
    actualBTree.clear();
    for (int i=0; i<n; i++) actualBTree.insert((int)random(99));
  }
  drawTree();
}

void draw() {
}

void drawMode() {
  int x=20, y=50;
  textFont(font, 24);
  textAlign(LEFT, CENTER);
  noStroke();

  fill(0);
  String modeText = (treeMode == 0) ? "Red-Black" : "B-Tree (M=3)";
  text(modeText, x, height-y);

  String traversalText = "";
  if (traversal == 0) traversalText = "inorder(t)";
  else if (traversal == 1) traversalText = "preorder(t)";
  else if (traversal == 2) traversalText = "postorder(t)";
  text(traversalText, x+140, height-y);

  text((int)(100.*mouseX/width)+"  insert", x+280, height-y);
  text("clear:c  new:b  toggle mode(RB/B-Tree):m  change traversal:t", x, height-24);
  stroke(192, 0, 0);
  textFont(font, 16);
  textAlign(CENTER, CENTER);
}

void drawTree() {
  background(200);
  if (treeMode == 0) {
    rbTree.assignPosition();
    rbTree.drawTree();
  } else {
    actualBTree.assignPosition();
    actualBTree.drawTree();
  }
  drawMode();
}

class RBTree {
  Node root;
  int  x, y, value, index;
  boolean RED = true;
  boolean BLACK = false;

  void clear() {
    root = null;
  }
  boolean isEmpty() {
    return root == null;
  }

  boolean checkRed(Node x) {
    if (x == null) return false;
    return x.isRed == RED;
  }

  Node rotateLeft(Node h) {
    Node x = h.right;
    h.right = x.left;
    x.left = h;
    x.isRed = h.isRed;
    h.isRed = RED;
    return x;
  }

  Node rotateRight(Node h) {
    Node x = h.left;
    h.left = x.right;
    x.right = h;
    x.isRed = h.isRed;
    h.isRed = RED;
    return x;
  }

  void flipColors(Node h) {
    h.isRed = !h.isRed;
    if (h.left != null) h.left.isRed = !h.left.isRed;
    if (h.right != null) h.right.isRed = !h.right.isRed;
  }

  boolean insert(int in) {
    root = insert(in, root);
    root.isRed = BLACK;
    return true;
  }

  Node insert(int in, Node h) {
    if (h == null) return new Node(in);
    if (in < h.val) h.left = insert(in, h.left);
    else if (in > h.val) h.right = insert(in, h.right);
    else return h;

    if (checkRed(h.right) && !checkRed(h.left)) h = rotateLeft(h);
    if (checkRed(h.left) && checkRed(h.left.left)) h = rotateRight(h);
    if (checkRed(h.left) && checkRed(h.right)) flipColors(h);
    return h;
  }

  void remove(int in) {
    root = remove(in, root);
    if (root != null) root.isRed = BLACK;
  }

  Node remove(int in, Node curr) {
    if (curr == null) return curr;
    if (in < curr.val) curr.left = remove(in, curr.left);
    else if (in > curr.val) curr.right = remove(in, curr.right);
    else if (curr.left != null && curr.right != null) {
      Node minNode = curr.right;
      while (minNode.left != null) minNode = minNode.left;
      curr.val = minNode.val;
      curr.right = remove(curr.val, curr.right);
    } else curr = (curr.left != null) ? curr.left:curr.right;
    return curr;
  }

  void assignPosition() {
    if (!isEmpty()) assignPosition(root, 0, width, 1);
  }
  void assignPosition(Node curr, float leftBound, float rightBound, int depth) {
    if (curr != null) {
      float center = (leftBound + rightBound) / 2.0;
      curr.x = center;
      curr.y = depth * ystep;

      assignPosition(curr.left, leftBound, center, depth + 1);
      assignPosition(curr.right, center, rightBound, depth + 1);
    }
  }

  void printTree() {
    fill(0, 0, 255);
    index=0;
    if (isEmpty()) println("The tree is empty");
    else printTree(root);
  }

  void printTree(Node curr) {
    if (curr != null) {
      if (traversal == 0) {
        printTree(curr.left);
        renderIndex(curr);
        printTree(curr.right);
      } else if (traversal == 1) {
        renderIndex(curr);
        printTree(curr.left);
        printTree(curr.right);
      } else if (traversal == 2) {
        printTree(curr.left);
        printTree(curr.right);
        renderIndex(curr);
      }
    }
  }

  void renderIndex(Node curr) {
    println(curr.val+" "+index+" ("+curr.x+","+curr.y+")");
    fill(0, 0, 255);
    textAlign(CENTER, CENTER);
    text(index, (int)(curr.x - radius/2 - 2), (int)(curr.y - radius/2 - 2));
    index++;
  }

  void findNode() {
    x = y = value = -1;
    if (!isEmpty()) findNode(root);
  }
  void findNode(Node curr) {
    if (curr != null) {
      findNode(curr.left);
      int dx=mouseX-(int)curr.x;
      int dy=mouseY-(int)curr.y;
      if ((dx*dx+dy*dy)<radius*radius/4) {
        x=(int)curr.x;
        y=(int)curr.y;
        value=curr.val;
        return;
      }
      findNode(curr.right);
    }
  }

  void drawTree() {
    if (!isEmpty()) {
      drawTreeLine(root);
      drawTree(root);
    }
  }
  void drawTreeLine(Node curr) {
    if (curr != null) {
      drawTreeLine(curr.left);
      stroke(192, 0, 0);
      strokeWeight(1);
      if (curr.left != null) line((int)curr.x, (int)curr.y, (int)curr.left.x, (int)curr.left.y);
      if (curr.right != null) line((int)curr.x, (int)curr.y, (int)curr.right.x, (int)curr.right.y);
      drawTreeLine(curr.right);
    }
  }

  void drawTree(Node curr) {
    if (curr != null) {
      drawTree(curr.left);

      if (curr.isRed) {
        fill(230, 80, 80);
      } else {
        fill(30, 30, 30);
      }
      stroke(0);
      ellipse(curr.x, curr.y, radius, radius);

      if (curr.isRed) {
        fill(textcolor==0 ? 0 : 255);
      } else {
        fill(255);
      }

      textAlign(CENTER, CENTER);
      text(curr.val, curr.x, curr.y);
      drawTree(curr.right);
    }
  }
}

class Node {
  int val;
  float x, y;
  Node left, right;
  boolean isRed;
  Node(int v) {
    val = v;
    isRed = true;
  }
}

class BTreeNode {
  int[] keys;
  BTreeNode[] children;
  int n;
  boolean isLeaf;
  float x, y;

  BTreeNode(int t, boolean isLeaf) {
    this.isLeaf = isLeaf;
    this.keys = new int[2 * t - 1];
    this.children = new BTreeNode[2 * t];
    this.n = 0;
  }
}

class BTree {
  BTreeNode root;
  int t;
  int x, y, value, index;

  BTree(int m) {
    this.t = (int)ceil(m / 2.0);
    this.root = null;
  }

  void clear() {
    root = null;
  }

  void insert(int k) {
    if (root == null) {
      root = new BTreeNode(t, true);
      root.keys[0] = k;
      root.n = 1;
      return;
    }

    if (root.n == 2 * t - 1) {
      BTreeNode s = new BTreeNode(t, false);
      s.children[0] = root;
      splitChild(s, 0, root);

      int i = 0;
      if (s.keys[0] < k) i++;
      insertNonFull(s.children[i], k);
      root = s;
    } else {
      insertNonFull(root, k);
    }
  }

  void insertNonFull(BTreeNode node, int k) {
    int i = node.n - 1;
    if (node.isLeaf) {
      while (i >= 0 && node.keys[i] > k) {
        node.keys[i + 1] = node.keys[i];
        i--;
      }
      node.keys[i + 1] = k;
      node.n = node.n + 1;
    } else {
      while (i >= 0 && node.keys[i] > k) i--;
      i++;
      if (node.children[i].n == 2 * t - 1) {
        splitChild(node, i, node.children[i]);
        if (node.keys[i] < k) i++;
      }
      insertNonFull(node.children[i], k);
    }
  }

  void splitChild(BTreeNode parent, int i, BTreeNode child) {
    BTreeNode z = new BTreeNode(t, child.isLeaf);
    z.n = t - 1;
    for (int j = 0; j < t - 1; j++) z.keys[j] = child.keys[j + t];
    if (!child.isLeaf) {
      for (int j = 0; j < t; j++) z.children[j] = child.children[j + t];
    }
    child.n = t - 1;

    for (int j = parent.n; j >= i + 1; j--) parent.children[j + 1] = parent.children[j];
    parent.children[i + 1] = z;

    for (int j = parent.n - 1; j >= i; j--) parent.keys[j + 1] = parent.keys[j];
    parent.keys[i] = child.keys[t - 1];
    parent.n = parent.n + 1;
  }

  void assignPosition() {
    if (root != null) assignPosition(root, 0, width, 1);
  }
  void assignPosition(BTreeNode node, float leftBound, float rightBound, int depth) {
    if (node != null) {

      node.x = (leftBound + rightBound) / 2.0;
      node.y = depth * ystep;
      if (!node.isLeaf) {
        float segmentWidth = (rightBound - leftBound) / (node.n + 1);
        for (int i = 0; i <= node.n; i++) {
          float nextLeft = leftBound + i * segmentWidth;
          float nextRight = nextLeft + segmentWidth;
          assignPosition(node.children[i], nextLeft, nextRight, depth + 1);
        }
      }
    }
  }
  void printTree() {
    fill(0, 0, 255);
    index=0;
    if (root == null) println("The tree is empty");
    else printTree(root);
  }
  void printTree(BTreeNode node) {
    if (node != null) {
      if (traversal == 0) {
        for (int i = 0; i < node.n; i++) {
          if (!node.isLeaf) printTree(node.children[i]);
          renderBTreeIndex(node, i);
        }
        if (!node.isLeaf) printTree(node.children[node.n]);
      } else if (traversal == 1) {
        for (int i = 0; i < node.n; i++) {
          renderBTreeIndex(node, i);
        }
        if (!node.isLeaf) {
          for (int i = 0; i <= node.n; i++) printTree(node.children[i]);
        }
      } else if (traversal == 2) {
        if (!node.isLeaf) {
          for (int i = 0; i <= node.n; i++) printTree(node.children[i]);
        }
        for (int i = 0; i < node.n; i++) {
          renderBTreeIndex(node, i);
        }
      }
    }
  }
  void renderBTreeIndex(BTreeNode node, int keyIdx) {
    println(node.keys[keyIdx]+" "+index+" ("+node.x+","+node.y+")");
    fill(0, 0, 255);
    textAlign(CENTER, CENTER);
    text(index, (int)(node.x - (radius * 0.8) + (keyIdx * 15)), (int)(node.y - 22));
    index++;
  }
  void findNode() {
    x = y = value = -1;
    if (root != null) findNode(root);
  }
  void findNode(BTreeNode node) {
    if (node != null) {
      if (mouseX >= node.x - radius && mouseX <= node.x + radius && mouseY >= node.y - 15 && mouseY <= node.y + 15) {
        x = (int)node.x;
        y = (int)node.y;
        if (node.n > 0) value = node.keys[0];
        return;
      }
      if (!node.isLeaf) {
        for (int i = 0; i <= node.n; i++) findNode(node.children[i]);
      }
    }
  }
  void drawTree() {
    if (root != null) {
      drawTreeLine(root);
      drawTree(root);
    }
  }
  void drawTreeLine(BTreeNode node) {
    if (node != null && !node.isLeaf) {
      stroke(0, 0, 192);
      strokeWeight(1);
      for (int i = 0; i <= node.n; i++) {
        if (node.children[i] != null) {
          line((int)node.x, (int)node.y, (int)node.children[i].x, (int)node.children[i].y);
          drawTreeLine(node.children[i]);
        }
      }
    }
  }
  void drawTree(BTreeNode node) {
    if (node != null) {
      fill(255);
      stroke(0);
      strokeWeight(1.5);
      rectMode(CENTER);
      rect(node.x, node.y, radius * 1.8, 30, 4);
      fill(textcolor == 0 ? 0 : 100);
      textAlign(CENTER, CENTER);
      String content = "";
      for (int i = 0; i < node.n; i++) {
        content += node.keys[i];
        if (i < node.n - 1) content += " | ";
      }
      text(content, node.x, node.y);
      if (!node.isLeaf) {
        for (int i = 0; i <= node.n; i++) drawTree(node.children[i]);
      }
    }
  }
}
