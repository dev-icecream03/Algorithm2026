int arr[];

void setup() {
  intArr(16);
  printArr();
  bubbleSorting();
  printArr();
}

void intArr(int n) {
  int i, j;
  arr = new int[n];
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void swap(int i, int j) {
  int tmp;
  tmp = arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}

void bubbleSorting() {
  int i, j;
  for(i=0; i<arr.length - 1; i++) {
    for(j=0; j<arr.length-i-1; j++) {
      if(arr[j]>arr[j+1]) {
        swap(j, j+1);
      }
    }
  } 
}
