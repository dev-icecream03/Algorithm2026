ArrayList<Array> lists;
Array list, plist, tlist;
int type=3, napTime=100, len=16, index=0, loop=0;
boolean autoFlag=true;
String[] titles = {"selectionSort", "bubbleSort", "insertSort", "mergeSort", "quikSort","heapSort"};
PFont f;

void setup() {
  size(900, 600);  
  f = createFont("Arial-BoldMT-48.vlw", 24);
  textFont(f);
  run(type);
}

void draw() {
  background(200);
  list = lists.get(index);
  list.draw();
  fill(0);
  if(list.i0 <= 0)
    text("("+nf(-list.i0,2)+","+nf(-list.j0,2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  else
    text("("+nf(list.i0,2)+","+nf(list.j0,2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  text(titles[type], 20, 40);
  if(autoFlag) nextStep();
}

void nextStep() {
  if(index==0)
    delay(10*napTime);
  else 
    delay(napTime);
  if(index<loop) index++;
  else index=0;
}

void keyPressed() {
  if(key == ' ') {
    autoFlag = !autoFlag;
  }
  else if(key == 'a') {
    if(napTime>100)
      napTime -= 100;
  }
  else if(key == 's') {
    napTime += 100;
  }
  else if(key == 'z') {
    if(type>0){
      type--;
      run(type);
    }  
  }
  else if(key == 'x') {
    if(type<5) {
      type++;
      run(type);
    }  
  }
  else if (key == CODED) {
    if (keyCode == LEFT) {
      if(index>0) index--;
    } else if (keyCode == RIGHT) {
      if(index<loop) index++;
    } 
  }
}

void mousePressed() {
  if(autoFlag) autoFlag=false;
  if(mouseButton == LEFT) {
    if(index>0) index--;
  }
  else if(mouseButton == RIGHT) {
    if(index<loop) index++;
  }
}

void run(int type) {
  loop = index = 0;
  tlist = new Array(len, 0, -1);
  lists = new ArrayList<Array>();
  lists.add(new Array(len, 0, -1));
  list = lists.get(0);
  list.printArray();
  if (type==0) selectionSort();
  else if (type==1) bubbleSort();
  else if (type==2) insertSort();
  else if (type==3) mergeSort();
  else if (type==4) quickSort();  
  else if (type==5) heapSort(); 
  list = lists.get(loop);
  list.printArray();
}

void selectionSort() {
  int i, j, max, index, tlen=len;
  for (i=0; i<len; i++) {
    plist = lists.get(i);
    lists.add(new Array(len, plist.arr, i+1, len-i-1));
    loop++;
    list = lists.get(i+1);    
    max=-1;
    index=-1;
    for (j=0; j<tlen; j++) {
      if (max<list.arr[j]) {
        max=list.arr[j];
        index=j;
      }
    }
    if (index!=-1) swap(list.arr, index, tlen-1);
    tlen--;
  }
}

void bubbleSort() {
  int i, j;
  for (j=0; j<len-1; j++) {
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, j+1, 0));
    loop++;
    for (i=0; i<len-j-1; i++) {
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, j+1, i+1));
      loop++;
      list = lists.get(loop);    
      if (list.arr[i] > list.arr[i+1])
        swap(list.arr, i, i+1);
    }
  }
}

void insertSort() {
  int i, j, temp;
  for (i=1; i<len; i++) {
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, i, i));
    loop++;
    list = lists.get(loop);    
    temp=list.arr[i];
    for (j=i-1; j>=0 && temp<list.arr[j]; j--) {
      list.arr[j+1] = list.arr[j];
    }
    list.arr[j+1] = temp;
  }
}

void mergeSort() {
  mergeSort(0, len-1);
}

void mergeSort(int low, int high) {
  if (low < high) {
    int middle = low + (high - low)/2;
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, -low, -high));
    loop++;
    list = lists.get(loop);    
    mergeSort(low, middle);
    mergeSort(middle + 1, high);
    merge(list, low, middle, high);
  }
}

void merge(Array list, int low, int middle, int high) {
  int i, j, k;
  i = low;
  j = middle + 1;
  k = low;
  for (i = low; i <= high; i++) 
    tlist.arr[i] = list.arr[i];
  for (i = low; i <= high; i++) {
    while (i <= middle && j <= high) {
      if (tlist.arr[i] <= tlist.arr[j]) {
        list.arr[k] = tlist.arr[i];
        i++;
      } 
      else {
        list.arr[k] = tlist.arr[j];
        j++;
      }
      k++;
    }
    while (i <= middle) {
      list.arr[k] = tlist.arr[i];
      k++;
      i++;
    }
  }
}


void quickSort() {
  quickSort(0, len - 1);
}

void quickSort(int low, int high) {
  if (low < high) {
    int i = low, j = high;
    int pivot = list.arr[low + (high - low) / 2];
    
    while (i <= j) {
      while (list.arr[i] < pivot) i++;
      while (list.arr[j] > pivot) j--;
      
      if (i <= j) {
        plist = lists.get(loop);
        lists.add(new Array(len, plist.arr, i, j));
        loop++;
        list = lists.get(loop);
        
        swap(list.arr, i, j);
        i++;
        j--;
      }
    }
    if (low < j) quickSort(low, j);
    if (i < high) quickSort(i, high);
  }
}

void heapSort() {
  int i, root, child;
  int n = len;

  // 1단계: 최대 힙(Max Heap) 구조로 바꾸는 과정.
  // 자식 없는 노드는 제외. 밑에서 위로 진행
  for (i = n / 2 - 1; i >= 0; i--) {
    root = i;
    
    while (2 * root + 1 < n) { // 1번 자식이 존재하는 검사. child에 부모 노드의 자식 노드 1번 담기, .
      child = 2 * root + 1;
      
      // 2번 자식이 존재하는지 검사. 1번 자식 노드보다 2번 자식 노드가 더 크면 2번 자식 노드를 선택, 
      if (child + 1 < n && list.arr[child] < list.arr[child + 1]) {
        child++;
      }
      
      //부모 노드가 자식 노드보다 작으면 서로 교환
      if (list.arr[root] < list.arr[child]) {
        plist = lists.get(loop);
        lists.add(new Array(len, plist.arr, root, child));
        loop++;
        list = lists.get(loop);
        
        swap(list.arr, root, child);
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
    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, 0, i));
    loop++;
    list = lists.get(loop);
    
    swap(list.arr, 0, i);
    
    root = 0;
    while (2 * root + 1 < i) {
      child = 2 * root + 1;
      
      if (child + 1 < i && list.arr[child] < list.arr[child + 1]) {
        child++;
      }
      
      if (list.arr[root] < list.arr[child]) {
        plist = lists.get(loop);
        lists.add(new Array(len, plist.arr, root, child));
        loop++;
        list = lists.get(loop);
        
        swap(list.arr, root, child);
        root = child;
      } else {
        break;
      }
    }
  }
}

void swap(int[] arr, int i, int j) {
  int tmp=arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}
