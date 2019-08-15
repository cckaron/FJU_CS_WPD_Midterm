//6 ball -> 5 plus and 1 minus
RoleThread role1;
RoleThread role2;

BallThread ball_5;
BallThread ball_4;
BallThread ball_3;
BallThread ball_2;
BallThread ball_1;
BallThread ball_minus_5;

TimerThread timer;
RefreshThread refreshHelper;
GradejudgeThread gradeJudge;
OnEatScannerThread onEatHelper;
GameStateThread gameStateHelper;

float x = 0;
boolean isW, isA, isS, isD, is5, is1, is2, is3;

PImage home;
PImage rule;


void setup(){
  size(1560, 822);
  ball_5 = new BallThread(3);
  ball_4 = new BallThread(5);
  ball_3 = new BallThread(7);
  ball_2 = new BallThread(9);
  ball_1 = new BallThread(11);
  ball_minus_5 = new BallThread(7);
  
  role1 = new RoleThread("Player A");
  role2 = new RoleThread("Player B");
  
  timer = new TimerThread();
  refreshHelper = new RefreshThread();
  
  gradeJudge = new GradejudgeThread();
  
  onEatHelper = new OnEatScannerThread();
  
  gameStateHelper = new GameStateThread();
  
  role1.start();
  role2.start();
  ball_5.start();
  ball_4.start();
  ball_3.start();
  ball_2.start();
  ball_1.start();
  ball_minus_5.start();
  timer.start();
  refreshHelper.start();
  gradeJudge.start();
  onEatHelper.start();
  gameStateHelper.start();
  
  //initialize ball position
  ball_5.init("img/ball/score5.png", 150, 150, 5);
  ball_4.init("img/ball/score4.png", 130, 130, 4);
  ball_3.init("img/ball/score3.png", 120, 120, 3);
  ball_2.init("img/ball/score2.png", 110, 110, 2);
  ball_1.init("img/ball/score1.png", 100, 100, 1);
  ball_minus_5.init("img/ball/ball_minus_5.png", 100, 100, -5);
  
  //initialize role
  role1.init("img/role/role1.png", 100, 100, 100, 100);
  role2.init("img/role/role2.png", 100, 100, 500, 500);
  
  gradeJudge.init();

}

void draw(){
  
  if (gameStateHelper.state == "GAME"){
    //game timer
    if (timer.startTimeInit == false){
      timer.init();
      timer.startTimeInit = true;
    };
    
    if (timer.getCountDownTime() == 0){
      gameStateHelper.setGameState("END");
    };
    
    background(255);
    ball_5.show();
    ball_4.show();
    ball_3.show();
    ball_2.show();
    ball_1.show();
    ball_minus_5.show();
    
    gradeJudge.judge();
    
    role1.show();
    role2.show();
    
    fill(0);
    textSize(50);
    text(role1.id + " " + role1.score, 300, 50);
    text(role2.id + " " + role2.score, 1000, 50);
    
    text(timer.getCountDownTime(), width/2, 50);
    
    if (timer.isRefreshTime()){
      refreshHelper.refreshEvent();
    };
  
    //control
    if (isW) role1.UP();
    if (isA) role1.LEFT();
    if (isS) role1.DOWN();
    if (isD) role1.RIGHT();
    if (is5) role2.UP();
    if (is1) role2.LEFT();
    if (is2) role2.DOWN();
    if (is3) role2.RIGHT();
    
    onEatHelper.onEatBallScanner();
    onEatHelper.onEatRoleScanner();
    
    if (role1.survive == false) role1.reviveHelper();
    if (role2.survive == false) role2.reviveHelper();
    
  } else if (gameStateHelper.state == "HOME"){
    home = loadImage("img/background/home.png");
    background(home);
    if (keyPressed){
      if (key == 'z'){
        gameStateHelper.setGameState("COUNTDOWN");
      }
      if (key =='x'){
        gameStateHelper.setGameState("RULE");
      }
    }
    
  } else if (gameStateHelper.state == "RULE"){
    rule = loadImage("img/background/rule.png");
    background(rule);
    if (keyPressed){
      if (key == 'z'){
        gameStateHelper.setGameState("COUNTDOWN");
      }
    }
    
    
  } else if (gameStateHelper.state == "COUNTDOWN"){
    if (timer.startBeforeGameCountDown == false){
      timer.beforegameCounDownStart();
    }
    
    if (timer.isBeforeGameCountDownEnd()){
      gameStateHelper.setGameState("GAME");
    } else {
      background(255);
      fill(0);
      textSize(300);
      text(timer.getBeforeGameCountdownTime(), width/2 - 100, height/2 + 100);
    }
  } else if (gameStateHelper.state == "END"){
    background(255);
    fill(0);
    textSize(50);
    text("Player A's Score:"+ role1.score + " .You eat your friend " + role1.eatRoleTime + " Time!!", width/2-500, height/2);
    text("Player B's Score:"+ role2.score + " .You eat your friend " + role2.eatRoleTime + " Time!!", width/2-500, height/2+100);
    textSize(100);
    fill(255, 0, 0);
    if (role1.score > role2.score){
      text("Winner is Player A!!!", width/2-400, height/2-100);
    } else if (role1.score < role2.score){
      text("Winner is Player B!!!", width/2-4600, height/2-100);
    } else if (role1.score == role2.score){
      text("Flat!!!", width/2-400, height/2-100);
    }
  };

  
}

void keyPressed(){
  setMove(key, true);
}

void keyReleased(){
  setMove(key, false);
}

boolean setMove(char k, boolean b){
  switch(k){
    case 'w':
      return isW = b;
    case 'a':
      return isA = b;
    case 's':
      return isS = b;
    case 'd':
      return isD = b;
    case '5':
      return is5 = b;
    case '1':
      return is1 = b;
    case '2':
      return is2 = b;
    case '3':
      return is3 = b;
    default:
      return b;
  }
}

void controller(){
  //controller
  if (keyPressed == true){
    
    if (key == 'w'){
      role1.UP();
    }
    if (key == 's'){
      role1.DOWN();
    } 
    if (key == 'a'){
      role1.LEFT();
    }
    if (key == 'd'){
      role1.RIGHT();
    }

    if (key == '5'){
      role2.UP();
    }
    if (key == '2'){
      role2.DOWN();
    } 
    if (key == '1'){
      role2.LEFT();
    }
    if (key == '3'){
      role2.RIGHT();
    }
  }
}
