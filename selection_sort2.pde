//int[] arr = {20, 12, 32, 9};
int[] arr;

void setup() {
  //size(500, 500);
  //println("In setup");
  int i, j, max, index, tmp;
  arr = new int[32];
  for (i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
  
  for (i=0; i<arr.length; i++ ) {
    print(arr[i], " ");
  }
  
  println();
  
  for (i=0; i<arr.length; i++ ) {
    max = index = -1;
    for(j=0; j<arr.length-i; j++) {
      if(max<arr[j]) {
        index = j;
        max = arr[j];
      }
    }
    tmp = arr[arr.length-i-1];
    arr[arr.length-i-1] = max;
    arr[index] = tmp;
  }
  
  for (i=0; i<arr.length; i++ ) {
    print(arr[i], " ");
  }
}

void draw() {
  //stroke(random(255), random(255), random(255));
  //line(random(500), random(500), random(500),  random(500));
  //line(0, 0, 300, 400);
  //println("In draw");
}
