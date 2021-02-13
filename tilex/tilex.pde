import java.util.*;
import java.util.Set;
import processing.sound.*; 

// Installing sound: https://stackoverflow.com/questions/30559754/how-to-install-the-sound-library-for-processing-in-a-simple-way

//Dimension

int dimension = 5;
int tileCount = dimension*dimension; 
int tileSize = 0; 
int stateCount = 10; 
int permutations = int(pow(2, tileCount)); 
int gamestate = 2; 
int replayvalue = 0; 
boolean kb = false;
PFont Freight; 
int neededtowin = 0;
int mistakes = 0;


int colour = 0;
int[] randoms = new Random().ints(0, tileCount).distinct().limit(5 / 2 * dimension + 1).toArray();

int[] green = Arrays.copyOfRange(randoms, 0, dimension);
int[] blue = Arrays.copyOfRange(randoms, dimension, 2 * dimension);
int[] red = Arrays.copyOfRange(randoms, 2 * dimension, 5 / 2 * dimension);
int[] gold = Arrays.copyOfRange(randoms, 5 / 2 * dimension, 5 / 2 * dimension + 1);

int pressCount = 0; 
int streak = -1;

PImage img[] = new PImage[stateCount]; 
Tile t[] = new Tile[tileCount]; 

SoundFile clickingSound; 
SoundFile dingSound; 

void setup() {
  Freight = loadFont("FreightDispProBlack-Regular-60.vlw"); 
  clickingSound = new SoundFile(this, "click.mp3"); 
  dingSound = new SoundFile(this, "ding.mp3"); 
  
  size(1024, 1024);
  tileSize = width/dimension;
  for (int i = 0; i <stateCount; i++) {
    img[i] = loadImage(i+".jpg");
  }
  for (int j = 0; j <tileCount; j++) {
    t[j] = new Tile((j%dimension)*tileSize, (j/dimension)*tileSize, 0);
  }
  
  PFont f;
  textAlign(CENTER);
  fill(0, 0, 128);
  f = createFont("Arial",18,true);
  textFont(f);
  text("The setting is 5012. The existing Federation has just lost their 50-year war against the Southern Alliance,", width/2, 200);
  text("and has decided to destroy the Earth in a final act of defiance. You,", width/2, 230);
  text("a mathematician, have been tasked with defusing the Federation’s nuclear warhead before it can detonate.", width/2, 260);
  text("To do so, you must continuously disarm the detonation buttons as they appear in waves on your screen.", width/2, 290);
  text("The fate of humanity rests in your hands - good luck. (Press 0 to start the game.)", width/2, 320);
  
}

void keyPressed() {
  kb = true;
  
  if (gamestate == 3) {
    gamestate = 2;
    streak = -1;
  }
  
}

void draw() {
  if (kb == true) {
    
    background(0); 
    for (int s = 0; s <tileCount; s++) {
      t[s].show();
    }
    
    gameState();
  }
}

//interaction
void mousePressed() {
  if (gamestate == 0) {
    gamestate = 1;
  }
  if (gamestate != 2) {
    //main interaction
    int xIn = int(mouseX/tileSize);
    int yIn = int(mouseY/tileSize); 
    int tileNumber = (yIn*dimension)+xIn; 
    
    boolean hit = false;
    if (colour == 1) {
      for (int k = 0; k < dimension; k++) {
        if (tileNumber == green[k]) {
          hit = true;
          pressCount++;
          t[tileNumber].tilestate = 1;
          green[k] = -1;
        }
      }
    }
    if (colour == 2) {
      for (int k = 0; k < dimension; k++) {
        if (tileNumber == blue[k]) {
          hit = true;
          pressCount++;
          t[tileNumber].tilestate = 2;
          blue[k] = -1;
        }
      }
    }
    if (colour == 3) {
      for (int k = 0; k < dimension / 2; k++) {
        if (tileNumber == red[k]) {
          hit = true;
          pressCount++;
          t[tileNumber].tilestate = 3;
          red[k] = -1;
        }
      }
    }
    if (colour == 4) {
      for (int k = 0; k < 1; k++) {
        if (tileNumber == gold[k]) {
          hit = true;
          pressCount++;
          t[tileNumber].tilestate = 4;
          gold[k] = -1;
        }
      }
    }
    
    if (hit == false) {
      mistakes++;
    }
    
  }
}

void gameStateCheck() {
  //win condition 
  
  
  if (pressCount == neededtowin) {
    //end win condition 
    gamestate = 2;
    dingSound.play();
  }
  
  if (mistakes >= 3) {
    gamestate = 3; 
    mistakes = 0;
  }
}

void gameState () {
  switch(gamestate) {
  case -1:
    kb = false;

    textFont(Freight); 
    textAlign(CENTER);
    fill(0);
    emptydisplay();
  case 0:
    gamestate = 1;
    textFont(Freight); 
    textAlign(CENTER);
    fill(0); 
    break; 
  case 1:
    //play state
    text("SCORE: " + streak, width/2, 50);
    text("LIVES: " + (3 - mistakes) + " /3", width/2, 100);
    if (colour == 1) {
      text("Select " + (dimension - 1) + " GREEN circles", width/2, 200);
      neededtowin = dimension - 1;
    } 
    if (colour == 2) {
      text("Select " + (dimension - 1) + " BLUE circles", width/2, 200);
      neededtowin = dimension - 1;
    } 
    if (colour == 3) {
      text("Select all RED circles", width/2, 200);
      neededtowin = dimension / 2;
    } 
    if (colour == 4) {
      text("Select all GOLD circles", width/2, 200);
      neededtowin = 1;
    }
    gameStateCheck();
    break;
  case 2:
    //win state
    textFont(Freight); 
    textAlign(CENTER);
    fill(255, 128, 0); 
    reset();
    break;
  case 3:
    textFont(Freight); 
    textAlign(CENTER);
    fill(0); 
    text("SCORE: " + streak, width/2, 50);
    text("GAME OVER", width/2, 200);
    text("HIT 0 TO RESTART", width/2, 300);
    
    for (int j = 0; j <tileCount; j++) {
      for (int k = 0; k < dimension; k++) {
          if (j == green[k]) {
            t[j].tilestate = 1;
          }
      }
      for (int k = 0; k < dimension; k++) {
          if (j == blue[k]) {
            t[j].tilestate = 2;
          }
      }
      for (int k = 0; k < dimension / 2; k++) {
          if (j == red[k]) {
            t[j].tilestate = 3;
          }
      }
      for (int k = 0; k < 1; k++) {
          if (j == gold[k]) {
            t[j].tilestate = 4;
          }
      }
    }
    break;
  }
}

void reset() {
  
    colour = new Random().ints(1, 5).distinct().limit(1).toArray()[0];
    streak += 1;
    
    gamestate = -1;
    pressCount = 0; 
    randoms = new Random().ints(0, tileCount).distinct().limit(5 * dimension / 2 + 1).toArray();

    green = Arrays.copyOfRange(randoms, 0, dimension);
    blue = Arrays.copyOfRange(randoms, dimension, 2 * dimension);
    red = Arrays.copyOfRange(randoms, 2 * dimension, 5 * dimension / 2);
    gold = Arrays.copyOfRange(randoms, 5 * dimension / 2, 5 * dimension / 2 + 1);
    
    print(green.length);
    print(blue.length);
    print(red.length);
    println(gold.length);
    
    for (int j = 0; j <tileCount; j++) {
      boolean in_random = false;
      for (int k = 0; k < dimension; k++) {
          if (j == green[k]) {
            in_random = true;
            t[j].tilestate = 1;
          }
      }
      for (int k = 0; k < dimension; k++) {
          if (j == blue[k]) {
            in_random = true;
            t[j].tilestate = 2;
          }
      }
      for (int k = 0; k < dimension / 2; k++) {
          if (j == red[k]) {
            in_random = true;
            t[j].tilestate = 3;
          }
      }
      for (int k = 0; k < 1; k++) {
          if (j == gold[k]) {
            in_random = true;
            t[j].tilestate = 4;
          }
      }
      if (in_random == false) {
        t[j].tilestate = 0;
      }
    }
    
    
}
//rules

void emptydisplay() {
  gamestate = 0;
  for (int j = 0; j <tileCount; j++) {
      t[j].tilestate = 0;
      //reset the game
  }
  kb = false;
  
}
