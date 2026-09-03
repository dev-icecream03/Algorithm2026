int[] list = new int[1000];
int i, j, index, tmp, max;

for(i=0; i<list.length; i++){
  list[i] = (int)random(1000);
}

println(list.length);

for(i=0; i<list.length; i++) {
   print(list[i], "");
}

println();

for(i=0; i < list.length; i++) {
  max = index = -1;
  int lastidx = list.length-1-i;
  
  for(j=0; j<=lastidx; j++) {
    if(max < list[j]) {
      max = list[j];
      index = j;
    }
  }
  
  if(index != -1) {
    tmp = list[lastidx];
    list[lastidx] = max;
    list[index] = tmp;
  }
}

for(i =0; i<list.length; i++) {
  print(list[i] + " ");
}
