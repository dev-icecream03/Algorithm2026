class Array {
  int i0, j0, len, max, w;
  int[] arr;

  Array(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    arr = new int[len];
    w = (int) (width-4)/len;
    shuffle();
  }

  Array(int len, int[] arr, int i0, int j0) {
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    this.arr = new int[len];
    w = (int) (width-4)/len;
    for (int i=0; i<len; i++)
      this.arr[i] = arr[i];
  }

  void draw() {
    int x, y, h;
    for (int i=0; i<len; i++) {
      if((j0 == i)) 
        fill(64);
      else
        fill(128);
      x = i*w+2;
      h = arr[i];
      y = height-5*h-60;
      rect(x, y, w, 5*h);
    }
  }
  
  int get(int index) {
    return arr[index];
  }
  
  int size() {
    return len;
  }

  void shuffle() {
    for (int i=0; i<len; i++)
      arr[i] = (int)random(max);
  }

  void printArray() {
    print("("+nf(i0,2)+","+nf(j0,2)+")- ");
    for (int i=0; i<len; i++)
      print(nf(arr[i],2)+" ");
    println();
  }
}
