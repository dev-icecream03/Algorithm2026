/**
 * 돌 놓기 문제 (Pebble Placement Problem) 알고리즘 시각화
 * - 3 x N 행렬 및 4가지 유효 패턴 DP(동적 계획법) 시각화
 * - [자동재생 버튼 / Space]: 자동 실행 및 일시정지 (배속 1x/2x 전환)
 * - [1단계 진행 / ->]: 한 단계씩 수동 진행
 * - [초기화 / R]: 0단계로 초기화
 * - [새 행렬 생성 / N]: 새로운 문제 무작위 생성
 * - DP 테이블 셀 클릭 시 해당 계산 단계로 즉시 이동
 */

int N = 8;
int[][] W = new int[3][N];
int[][] dp = new int[N][4];
int[][] prev = new int[N][4];
int[] opt = new int[N];

// 4가지 유효 패턴 (행 0, 1, 2)
boolean[][] pat = {
  { true,  false, false }, // 패턴 1 (1행)
  { false, true,  false }, // 패턴 2 (2행)
  { false, false, true  }, // 패턴 3 (3행)
  { true,  false, true  }  // 패턴 4 (1&3행)
};

// 양립 가능한(가로로 맞닿지 않는) 이전 패턴 목록
int[][] compat = {
  { 1, 2 },       // P1 <- P2, P3
  { 0, 2, 3 },    // P2 <- P1, P3, P4
  { 0, 1 },       // P3 <- P1, P2
  { 1 }           // P4 <- P2
};

int step = 0; // 0 ~ N*4
boolean play = false;
int playSpeed = 22; // 재생 딜레이 (프레임 단위)

public void settings() {
  size(1020, 640);
}

public void setup() {
  surface.setTitle("돌 놓기 문제 (Pebble Placement DP) 시각화");
  textFont(createFont("Malgun Gothic", 13));
  initData();
}

void initData() {
  int[][] sample = {
    { 12, 24,  6, 32, 14, 18, 28, 15 },
    {  8,  5, 45,  7, 26,  9, 12, 35 },
    { 16, 20,  4, 28,  8, 22, 19, 10 }
  };
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < N; c++) W[r][c] = sample[r][c];
  }
  calcDP();
  step = 0;
  play = false;
}

void randomize() {
  for (int r = 0; r < 3; r++) {
    for (int c = 0; c < N; c++) W[r][c] = (int)random(-5, 40);
  }
  calcDP();
  step = 0;
  play = false;
}

int weight(int c, int p) {
  if (p == 0) return W[0][c];
  if (p == 1) return W[1][c];
  if (p == 2) return W[2][c];
  return W[0][c] + W[2][c];
}

void calcDP() {
  // 기저 조건 (1번째 열)
  for (int p = 0; p < 4; p++) {
    dp[0][p] = weight(0, p);
    prev[0][p] = -1;
  }

  // 점화식 계산 (2번째 열 ~ N번째 열)
  for (int c = 1; c < N; c++) {
    for (int p = 0; p < 4; p++) {
      int maxV = -999999, bestQ = -1;
      for (int q : compat[p]) {
        if (dp[c - 1][q] > maxV) {
          maxV = dp[c - 1][q];
          bestQ = q;
        }
      }
      dp[c][p] = maxV + weight(c, p);
      prev[c][p] = bestQ;
    }
  }

  // 최적 경로 역추적 (Backtracking)
  int maxFinal = -999999, lastP = 0;
  for (int p = 0; p < 4; p++) {
    if (dp[N - 1][p] > maxFinal) {
      maxFinal = dp[N - 1][p];
      lastP = p;
    }
  }
  int cur = lastP;
  for (int c = N - 1; c >= 0; c--) {
    opt[c] = cur;
    if (c > 0) cur = prev[c][cur];
  }
}

public void draw() {
  background(20, 26, 36);

  // 자동 재생 제어
  if (play && frameCount % playSpeed == 0) {
    if (step < N * 4) {
      step++;
    } else {
      play = false;
    }
  }

  int curC = step < N * 4 ? step / 4 : N;
  int curP = step < N * 4 ? step % 4 : -1;
  boolean done = (step >= N * 4);

  // --- 1. 상단 타이틀 & 컨트롤 버튼 바 ---
  fill(255);
  textSize(17);
  textAlign(LEFT, CENTER);
  text("돌 놓기 문제 (Pebble Placement DP)", 40, 28);

  // 상단 우측 버튼들 (이모지 대신 깨짐 없는 표준 한글 텍스트 적용)
  drawButton(520, 14, 105, 30, play ? "일시정지" : "자동재생", play ? color(220, 50, 70) : color(40, 160, 90));
  drawButton(635, 14, 95, 30, "1단계 진행", color(55, 75, 100));
  drawButton(740, 14, 80, 30, "초기화", color(55, 75, 100));
  drawButton(830, 14, 105, 30, "새 행렬 생성", color(70, 60, 140));
  drawButton(945, 14, 40, 30, playSpeed == 22 ? "1x" : "2x", color(45, 55, 70));

  // --- 2. 상태 및 수식 설명 카드 ---
  fill(28, 36, 48);
  stroke(45, 58, 76);
  rect(40, 52, width - 80, 32, 5);

  textSize(13);
  if (done) {
    fill(50, 220, 140);
    textAlign(LEFT, CENTER);
    String pathStr = "";
    for (int c = 0; c < N; c++) pathStr += "P" + (opt[c] + 1) + (c < N - 1 ? " -> " : "");
    text("[완료] 모든 DP 계산 완료!  최적 최고 점수 = " + dp[N - 1][opt[N - 1]] + "점  |  최적 선택 경로: " + pathStr, 55, 68);
  } else {
    fill(255, 200, 60);
    textAlign(LEFT, CENTER);
    if (curC == 0) {
      text("[진행] Step " + (step + 1) + "/" + (N * 4) + " (Col 1, 패턴 " + (curP + 1) + ") 기저 조건: dp[1][" + (curP + 1) + "] = W[1][" + (curP + 1) + "] = " + dp[0][curP], 55, 68);
    } else {
      int bestQ = prev[curC][curP];
      text("[진행] Step " + (step + 1) + "/" + (N * 4) + " (Col " + (curC + 1) + ", 패턴 " + (curP + 1) + ") 점화식: W(" + weight(curC, curP) + ") + max(이전후보=" + dp[curC - 1][bestQ] + ") = dp[" + (curC + 1) + "][" + (curP + 1) + "] = " + dp[curC][curP], 55, 68);
    }
  }

  // --- 3. 3xN 원본 행렬 뷰 ---
  float startX = 110, startY = 138;
  float cellW = (width - 150) / (float)N;
  float cellH = 40;

  // 섹션 타이틀 (y=102에 단독 배치)
  fill(200, 215, 230);
  textSize(14);
  textAlign(LEFT, CENTER);
  text("[1] 3 x " + N + " 원본 행렬 및 돌 배치 현황", 40, 102);

  // 열 번호 헤더 (y=122에 단독 배치)
  textSize(12);
  for (int c = 0; c < N; c++) {
    fill(c == curC && !done ? color(60, 180, 255) : color(140, 155, 175));
    textAlign(CENTER, CENTER);
    text("Col " + (c + 1), startX + c * cellW + cellW / 2, 122);
  }

  // 행 번호 헤더 및 셀
  for (int r = 0; r < 3; r++) {
    fill(140, 155, 175);
    textAlign(RIGHT, CENTER);
    text((r + 1) + "행", startX - 12, startY + r * cellH + cellH / 2);

    for (int c = 0; c < N; c++) {
      float x = startX + c * cellW;
      float y = startY + r * cellH;

      // 셀 배경
      fill(c == curC && !done ? color(32, 54, 76) : color(28, 36, 48));
      stroke(c == curC && !done ? color(60, 160, 250) : color(45, 58, 76));
      rect(x + 2, y + 2, cellW - 4, cellH - 4, 4);

      // 돌 배치 판단
      boolean stone = false;
      int stoneColor = color(60, 160, 250);
      if (done) {
        stone = pat[opt[c]][r];
        stoneColor = color(40, 200, 120);
      } else if (c == curC && curP >= 0) {
        stone = pat[curP][r];
        stoneColor = color(245, 170, 30);
      } else if (c == curC - 1 && curC > 0 && curP >= 0) {
        int bestQ = prev[curC][curP];
        stone = pat[bestQ][r];
        stoneColor = color(60, 160, 250);
      }

      // 돌이 있으면 먼저 깔끔한 단색 원 그리기
      if (stone) {
        fill(stoneColor);
        noStroke();
        ellipse(x + cellW / 2, y + cellH / 2, cellH * 0.72f, cellH * 0.72f);
      }

      // 숫자 그리기 (돌 위에 오도록 항상 최상단에 렌더링)
      textSize(13);
      fill(stone ? color(20, 24, 30) : color(220, 230, 240));
      textAlign(CENTER, CENTER);
      text(W[r][c], x + cellW / 2, y + cellH / 2);
    }
  }

  // --- 4. 4xN DP 테이블 ---
  float dpY = 320;

  // DP 섹션 타이틀 (y=284에 단독 배치)
  fill(200, 215, 230);
  textSize(14);
  textAlign(LEFT, CENTER);
  text("[2] 4 x " + N + " DP 테이블 (누적 최댓값 기록)", 40, 284);

  // DP 열 번호 헤더 (y=304에 단독 배치)
  textSize(12);
  for (int c = 0; c < N; c++) {
    fill(c == curC && !done ? color(60, 180, 255) : color(140, 155, 175));
    textAlign(CENTER, CENTER);
    text("Col " + (c + 1), startX + c * cellW + cellW / 2, 304);
  }

  // 행 라벨 (P1 ~ P4)
  String[] pNames = { "P1 (1행)", "P2 (2행)", "P3 (3행)", "P4 (1&3행)" };
  for (int p = 0; p < 4; p++) {
    fill(140, 155, 175);
    textSize(12);
    textAlign(RIGHT, CENTER);
    text(pNames[p], startX - 12, dpY + p * cellH + cellH / 2);
  }

  // 이전 후보 연결선
  if (curC > 0 && curC < N && curP >= 0 && !done) {
    float tx = startX + curC * cellW;
    float ty = dpY + curP * cellH + cellH / 2;
    int bestQ = prev[curC][curP];
    for (int q : compat[curP]) {
      float sx = startX + (curC - 1) * cellW + cellW;
      float sy = dpY + q * cellH + cellH / 2;
      stroke(q == bestQ ? color(50, 220, 140) : color(60, 120, 180, 120));
      strokeWeight(q == bestQ ? 2.5f : 1);
      line(sx, sy, tx, ty);
    }
    strokeWeight(1);
  }

  // 최적 경로 연결선
  if (done) {
    stroke(50, 220, 140);
    strokeWeight(2.5f);
    for (int c = 0; c < N - 1; c++) {
      line(startX + c * cellW + cellW / 2, dpY + opt[c] * cellH + cellH / 2,
           startX + (c + 1) * cellW + cellW / 2, dpY + opt[c + 1] * cellH + cellH / 2);
    }
    strokeWeight(1);
  }

  // DP 셀 그리기
  for (int c = 0; c < N; c++) {
    for (int p = 0; p < 4; p++) {
      float x = startX + c * cellW;
      float y = dpY + p * cellH;
      int idx = c * 4 + p;
      boolean isCur = (c == curC && p == curP && !done);
      boolean isOpt = (done && opt[c] == p);

      if (isCur) {
        fill(55, 50, 25);
        stroke(245, 170, 30);
      } else if (isOpt) {
        fill(25, 55, 40);
        stroke(50, 220, 140);
      } else {
        fill(idx <= step ? color(28, 36, 48) : color(22, 28, 36));
        stroke(45, 58, 76);
      }
      rect(x + 2, y + 2, cellW - 4, cellH - 4, 4);

      if (idx <= step) {
        textSize(13);
        fill(isOpt ? color(50, 220, 140) : (isCur ? color(255, 190, 40) : color(220, 230, 240)));
        textAlign(CENTER, CENTER);
        text(dp[c][p], x + cellW / 2, y + cellH / 2);
      }
    }
  }

  // --- 5. 하단 4가지 패턴 & 전이 규칙 레퍼런스 카드 ---
  float refY = 506;
  fill(26, 32, 42);
  stroke(45, 58, 76);
  rect(40, refY, width - 80, 115, 6);

  fill(170, 185, 205);
  textSize(13);
  textAlign(LEFT, TOP);
  text("패턴별 돌 배치 및 인접 열 양립 가능(Compatible) 조건", 55, refY + 12);

  float cardW = (width - 120) / 4f;
  String[] patDetails = {
    "패턴 1 (1행만)", "패턴 2 (2행만)", "패턴 3 (3행만)", "패턴 4 (1&3행)"
  };
  String[] patCompats = {
    "이전 가능: P2, P3", "이전 가능: P1, P3, P4", "이전 가능: P1, P2", "이전 가능: P2 (단 하나)"
  };

  for (int p = 0; p < 4; p++) {
    float cx = 55 + p * cardW;
    float cy = refY + 36;
    fill(p == curP && !done ? color(40, 50, 65) : color(20, 26, 34));
    stroke(p == curP && !done ? color(245, 170, 30) : color(45, 58, 76));
    rect(cx, cy, cardW - 10, 64, 4);

    // 미니 3도트 프리뷰
    for (int r = 0; r < 3; r++) {
      fill(pat[p][r] ? color(60, 160, 250) : color(55, 65, 80));
      noStroke();
      ellipse(cx + 18, cy + 16 + r * 16, 9, 9);
    }

    // 패턴 설명 텍스트
    textAlign(LEFT, TOP);
    textSize(12);
    fill(p == curP && !done ? color(255, 200, 60) : color(220, 230, 240));
    text(patDetails[p], cx + 32, cy + 14);

    textSize(11);
    fill(140, 155, 175);
    text(patCompats[p], cx + 32, cy + 36);
  }
}

void drawButton(float x, float y, float w, float h, String label, int bg) {
  boolean hover = mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  fill(hover ? lerpColor(bg, color(255), 0.2f) : bg);
  stroke(hover ? 255 : 80);
  rect(x, y, w, h, 5);

  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2 - 1);
}

public void mousePressed() {
  // 상단 버튼 클릭
  if (isMouseOver(520, 14, 105, 30)) { // 자동재생 토글
    if (step >= N * 4) step = 0;
    play = !play;
    return;
  }
  if (isMouseOver(635, 14, 95, 30)) { // 1단계 진행
    if (step < N * 4) step++;
    play = false;
    return;
  }
  if (isMouseOver(740, 14, 80, 30)) { // 리셋
    step = 0;
    play = false;
    return;
  }
  if (isMouseOver(830, 14, 105, 30)) { // 새 행렬
    randomize();
    return;
  }
  if (isMouseOver(945, 14, 40, 30)) { // 배속 전환
    playSpeed = (playSpeed == 22) ? 10 : 22;
    return;
  }

  // DP 테이블 셀 클릭 시 해당 단계로 즉시 점프
  float startX = 110, dpY = 320;
  float cellW = (width - 150) / (float)N, cellH = 40;
  for (int c = 0; c < N; c++) {
    for (int p = 0; p < 4; p++) {
      float x = startX + c * cellW;
      float y = dpY + p * cellH;
      if (isMouseOver(x, y, cellW, cellH)) {
        step = c * 4 + p;
        play = false;
        return;
      }
    }
  }
}

boolean isMouseOver(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

public void keyPressed() {
  if (key == ' ') {
    if (step >= N * 4) step = 0;
    play = !play;
  } else if (keyCode == RIGHT) {
    if (step < N * 4) step++;
    play = false;
  } else if (keyCode == LEFT) {
    if (step > 0) step--;
    play = false;
  } else if (key == 'r' || key == 'R') {
    step = 0;
    play = false;
  } else if (key == 'n' || key == 'N') {
    randomize();
  }
}
