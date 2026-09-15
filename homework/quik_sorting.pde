int arr[];

void setup() {
  intArr(16);
  printArr();
  quickSorting(0, arr.length - 1);
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

void quickSorting(int left, int right) {
  int i, j;
  int pivot;

  if (left < right) {
    pivot = arr[right];
    i = left - 1;

    for (j = left; j < right; j++) {
      if (arr[j] < pivot) {
        i++;
        swap(i, j);
      }
    }
    swap(i + 1, right);

    quickSorting(left, i);
    quickSorting(i + 2, right);
  }
}
