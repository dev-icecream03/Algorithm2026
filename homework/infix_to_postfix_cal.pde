import java.util.Stack;

String inputText = "12*(34+6)/20^1";
String postfixResult = "";
String calculationResult = ""; 
PFont myFont;

int cursorPos = 0; 

void setup() {
  size(600, 360); 
  
  myFont = createFont("Malgun Gothic", 24);
  textFont(myFont);
  
  cursorPos = inputText.length(); 
  updateAll(); 
}

void draw() {
  background(240); 
  
  fill(120);
  textSize(14);
  text("두 자리 이상의 숫자 연산이 가능합니다. (예: 12 + 345)", 50, 70);
  
  // 1. Infix 입력창
  fill(0);
  textSize(22);
  text("Infix (입력):", 50, 130);
  
  float textStartX = 200;
  float textY = 130;
  
  String firstPart = inputText.substring(0, cursorPos);
  fill(0, 102, 204);
  text(firstPart, textStartX, textY);
  
  float cursorX = textStartX + textWidth(firstPart);
  if ((millis() / 500) % 2 == 0) { 
    fill(255, 0, 0); 
    text("|", cursorX - 2, textY - 2); 
  }
  
  String secondPart = inputText.substring(cursorPos, inputText.length());
  fill(0, 102, 204);
  text(secondPart, cursorX, textY);
  
  stroke(200);
  line(50, 165, 550, 165);
  
  // 2. Postfix 결과창
  fill(0);
  text("Postfix (변환):", 50, 210);
  fill(204, 0, 102); 
  text(postfixResult, 200, 210);

  stroke(200);
  line(50, 245, 550, 245);
  
  // 3. 수식 계산 결과창
  fill(0);
  text("Value (연산 결과):", 50, 290);
  
  if (calculationResult.startsWith("Error") || calculationResult.startsWith("변수")) {
    fill(220, 50, 50); 
  } else {
    fill(0, 153, 76); 
  }
  text(calculationResult, 250, 290);
}

void updateAll() {
  postfixResult = infixToPostfix(inputText);
  calculationResult = evaluatePostfix(postfixResult);
}

void mousePressed() {
  float textStartX = 200;
  float textEndX = textStartX + textWidth(inputText);
  
  if (mouseY > 100 && mouseY < 150 && mouseX >= textStartX - 10 && mouseX <= textEndX + 10) {
    float closestDist = Float.MAX_VALUE;
    int closestIndex = 0;
    for (int i = 0; i <= inputText.length(); i++) {
      float partWidth = textWidth(inputText.substring(0, i));
      float currentX = textStartX + partWidth;
      float d = abs(mouseX - currentX);
      if (d < closestDist) {
        closestDist = d;
        closestIndex = i;
      }
    }
    cursorPos = closestIndex;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (cursorPos > 0) cursorPos--;
    } else if (keyCode == RIGHT) {
      if (cursorPos < inputText.length()) cursorPos++;
    }
  } 
  else if (key == BACKSPACE) {
    if (cursorPos > 0 && inputText.length() > 0) {
      String firstPart = inputText.substring(0, cursorPos - 1);
      String secondPart = inputText.substring(cursorPos, inputText.length());
      inputText = firstPart + secondPart;
      cursorPos--; 
    }
  } 
  else if (key == DELETE) {
    if (cursorPos < inputText.length() && inputText.length() > 0) {
      String firstPart = inputText.substring(0, cursorPos);
      String secondPart = inputText.substring(cursorPos + 1, inputText.length());
      inputText = firstPart + secondPart;
    }
  } 
  else if (key != ENTER && key != RETURN && key != TAB && key != ESC) {
    String firstPart = inputText.substring(0, cursorPos);
    String secondPart = inputText.substring(cursorPos, inputText.length());
    inputText = firstPart + key + secondPart;
    cursorPos++; 
  }
  
  updateAll();
}

int prec(char c) {
  if (c == '^') return 3;
  else if (c == '/' || c == '*') return 2;
  else if (c == '+' || c == '-') return 1;
  return -1;
}

boolean isRightAssociative(char c) {
  return c == '^';
}

String infixToPostfix(String s) {
  Stack<Character> st = new Stack<Character>();
  StringBuilder res = new StringBuilder();

  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);

    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) {
      res.append(c);
      if (i + 1 < s.length()) {
        char next = s.charAt(i + 1);
        if (!((next >= 'a' && next <= 'z') || (next >= 'A' && next <= 'Z') || (next >= '0' && next <= '9'))) {
          res.append(" ");
        }
      } else {
        res.append(" ");
      }
    } 
    else if (c == '(') {
      st.push('(');
    } 
    else if (c == ')') {
      while (!st.isEmpty() && st.peek() != '(') {
        res.append(st.pop()).append(" ");
      }
      if (!st.isEmpty()) st.pop();
    } 

    else if (c == '+' || c == '-' || c == '*' || c == '/' || c == '^') {
      while (!st.isEmpty() && st.peek() != '(' &&
             (prec(st.peek()) > prec(c) ||
             (prec(st.peek()) == prec(c) && !isRightAssociative(c)))) {
        res.append(st.pop()).append(" ");
      }
      st.push(c);
    }
  }

  while (!st.isEmpty()) {
    res.append(st.pop()).append(" ");
  }


  return res.toString().trim();
}

// --- 후위 표기법 계산 알고리즘 (공백 단위 파싱) ---
String evaluatePostfix(String postfix) {
  if (postfix.equals("")) return "0";
  
  Stack<Double> stack = new Stack<Double>();
  String[] tokens = postfix.split("\\s+");
  
  for (String token : tokens) {
    if (token.isEmpty()) continue;
    
    char firstChar = token.charAt(0);
    
    if (firstChar >= '0' && firstChar <= '9') {
      try {
        stack.push(Double.parseDouble(token));
      } catch (NumberFormatException e) {
        return "Error (숫자 파싱 오류)";
      }
    } 
    else if ((firstChar >= 'a' && firstChar <= 'z') || (firstChar >= 'A' && firstChar <= 'Z')) {
      return "변수가 포함되어 계산할 수 없습니다.";
    } 
    else if (token.length() == 1 && (firstChar == '+' || firstChar == '-' || firstChar == '*' || firstChar == '/' || firstChar == '^')) {
      if (stack.size() < 2) return "Error (잘못된 수식)";
      
      double val2 = stack.pop();
      double val1 = stack.pop();
      
      switch (firstChar) {
        case '+': stack.push(val1 + val2); break;
        case '-': stack.push(val1 - val2); break;
        case '*': stack.push(val1 * val2); break;
        case '/': 
          if (val2 == 0) return "Error (0으로 나눌 수 없음)";
          stack.push(val1 / val2); 
          break;
        case '^': stack.push(Math.pow(val1, val2)); break;
      }
    }
  }
  
  if (stack.size() != 1) return "Error (연산자 오류)";
  
  double finalVal = stack.pop();
  if (finalVal == (long) finalVal) {
    return String.format("%d", (long) finalVal);
  } else {
    return String.format("%.2f", finalVal);
  }
}
