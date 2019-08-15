class TimerThread extends Thread{
  
  //used in beforegame coundown
  int countdownTime;
  int start_countdownTime;
  int end_countdownTime;
  boolean startBeforeGameCountDown;
  
  int startTime;
  int elapsedTime;
  int gameTime = 60;
  int start_refresh_time;
  int timegap;
  int timegap_accumulator;
  boolean startTimeInit;
  
  TimerThread(){
  }
  
  void init(){
    startTime = millis();
    timegap = 10000;
    timegap_accumulator = 0;
    countdownTime = 5;
  }
  
  int getCountDownTime(){
    return gameTime+int(startTime/1000)-int(millis()/1000);
  }
  
  boolean isRefreshTime(){
    if (millis() - startTime > timegap_accumulator){ 
      timegap_accumulator += timegap;
      return true;
    }
    return false;
  }
  
  void beforegameCounDownStart(){
    startBeforeGameCountDown = true;
    start_countdownTime = int(millis()/1000);
    end_countdownTime = start_countdownTime + 6;
    println("before count down start!");
  }
  
  int getBeforeGameCountdownTime(){
    return end_countdownTime - int(millis()/1000);
  }
  
  boolean isBeforeGameCountDownEnd(){
    if (end_countdownTime - int(millis()/1000) < 0){
      startBeforeGameCountDown = false;
      return true;
    }
    return false;
  }
}
