int arr[];

void setup() {
  intArr(16);
  printArr();
  mergeSorting();
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

void mergeSorting() {
  int[] temp = new int[arr.length];
  int size, left, mid, right;
  int i, j, k, x;
  
  for (size = 1; size < arr.length; size *= 2) {
    for (left = 0; left < arr.length - 1; left += 2 * size) {
      mid = left + size - 1;
      
      // 해당 리스트와 합칠 대상이 없을 경우 스킵한다. 
      if (mid >= arr.length - 1) {
        continue;
      }
      
      // 우측 리스트의 끝을 right에 담는다. 만약 우측 리스트의 길이가 지정된 사이즈보다 작으면 원본 배열의 끝을 넣는다. 
      if (left + 2 * size - 1 >= arr.length) {
        right = arr.length - 1;
      } else {
        right = left + 2 * size - 1;
      }
      
      i = left;
      j = mid + 1;
      k = left;
      
      // 두 리스트의 값들을 1대1로 비교후 작은 값을 temp에 넣는다. 선택된 리스트와 temp의 인덱스를 하나 올린다.
      while (i <= mid && j <= right) {
        if (arr[i] <= arr[j]) {
          temp[k++] = arr[i++];
        } else {
          temp[k++] = arr[j++];
        }
      }
      
      // 좌측 혹은 우측 리스트에서 남은 값들 이어붙이기
      while (i <= mid) {
        temp[k++] = arr[i++];
      }
      while (j <= right) {
        temp[k++] = arr[j++];
      }
      
      // 원본 리스트에 결과 반영
      for (x = left; x <= right; x++) {
        arr[x] = temp[x];
      }
    }
  }
}
