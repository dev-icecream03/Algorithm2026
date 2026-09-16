int arr[];

void setup() {
  intArr(16);
  printArr();
  heapSorting();
  printArr();
}

void intArr(int n) {
  int i;
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

void heapSorting() {
  int i, root, child;
  int n = arr.length;

  // 1단계: 최대 힙(Max Heap) 구조로 바꾸는 과정.
  // 자식 없는 노드는 제외. 밑에서 위로 진행
  for (i = n / 2 - 1; i >= 0; i--) {
    root = i;
    
    while (2 * root + 1 < n) { // 1번 자식이 존재하는 검사. child에 부모 노드의 자식 노드 1번 담기, .
      child = 2 * root + 1;
      
      // 2번 자식이 존재하는지 검사. 1번 자식 노드보다 2번 자식 노드가 더 크면 2번 자식 노드를 선택, 
      if (child + 1 < n && arr[child] < arr[child + 1]) {
        child++;
      }
      
      //부모 노드가 자식 노드보다 작으면 서로 교환
      if (arr[root] < arr[child]) {
        swap(root, child);
        root = child; // 교환 후에도 아래에 자신보다 큰 자식이 있는지 판별하기 위해 root를 조정
      } else {
        break;
      }
    }
  }
  
  // 2단계: 수가 큰 놈들을 차례대로 밑으로 보내기
  // 전체적인 흐름은 1단계와 같으나 범위를 전체나 하냐, 이미 정렬된 부분을 빼고 하냐의 차이.
  // 가장 바깥쪽 반복문이 한 번 끝날때마다 하나씩 정렬.
  for (i = n - 1; i > 0; i--) {
    // 제일 큰 값 맨 뒤로 보내기
    swap(0, i);
    
    root = 0;
    while (2 * root + 1 < i) {
      child = 2 * root + 1;
      
      if (child + 1 < i && arr[child] < arr[child + 1]) {
        child++;
      }
      
      if (arr[root] < arr[child]) {
        swap(root, child);
        root = child;
      } else {
        break;
      }
    }
  }
}
