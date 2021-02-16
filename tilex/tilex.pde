import java.util.*;
import java.util.Set;
import processing.sound.*; 

// Installing sound: https://stackoverflow.com/questions/30559754/how-to-install-the-sound-library-for-processing-in-a-simple-way

//Dimension

int dimension = 5;
int tileCount = dimension*dimension; 
int tileSize = 0; 
int stateCount = 6; 
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
SoundFile arrowSound;
SoundFile deathSound;
SoundFile gruntSound;

void setup() {
  Freight = loadFont("Minecraft-18.vlw"); 
  clickingSound = new SoundFile(this, "click.mp3"); 
  dingSound = new SoundFile(this, "ding.mp3"); 
  arrowSound = new SoundFile(this, "arrowSound.mp3");
  deathSound = new SoundFile(this, "deathSound.mp3");
  gruntSound = new SoundFile(this, "gruntSound.mp3"); 
  size(1024, 1024);
  tileSize = width/dimension;
  for (int i = 0; i <stateCount; i++) {
    img[i] = loadImage(i+".png");
  }
  for (int j = 0; j <tileCount; j++) {
    t[j] = new Tile((j%dimension)*tileSize, (j/dimension)*tileSize, 0);
  }
  
  PFont f;
  textAlign(CENTER);
  fill(0, 0, 128);
  f = loadFont("Minecraft-18.vlw");
  textFont(f);
  text("Oh my Herobrine! You're awake.", width/2, 200);
  text("Welcome to Minecraft!", width/2, 260);
  text("I spent a long time developing you - my redstone creation. ", width/2, 300);
  text("This is an amazing world with many things to do and explore!", width/2, 340);
  text("But unfortunately, before you get to experience that, you'll be here for a little while. ", width/2, 380);
  text("Your job is to analyze the soil and relay back to me where the ores are. Got that? ", width/2, 420);
  text("I'll put you through some tests first. Let's see if you can do it. ", width/2, 460);
  text("When you're ready, press any key to start the simulation. ", width/2, 500);
  
  
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
          arrowSound.play();
          break;
        }
        else {
        t[tileNumber].tilestate = 5;         
        gruntSound.play();

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
          arrowSound.play();

          break;

        } else {
        t[tileNumber].tilestate = 5;         
        gruntSound.play();

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
          arrowSound.play();

          break;
        }
        else {
        t[tileNumber].tilestate = 5;         
        gruntSound.play();

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
          arrowSound.play();

          break;
        }else {
        t[tileNumber].tilestate = 5; 
        gruntSound.play();
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
    arrowSound.play();
  }
  
  if (mistakes >= 3) {
    gamestate = 3; 
    mistakes = 0;
  }
  
}

void gameState () {
  
  PFont f;
  textAlign(CENTER);
  fill(0, 0, 128);
  f = loadFont("Minecraft-18.vlw");
  textFont(f);
  switch(gamestate) {
  case -1:
    kb = false;
    // text("GAMESTATE -1", width/2, 200);

    fill(0);
    emptydisplay();
  case 0:
    gamestate = 1;
    // text("GAMESTATE 0", width/2, 300);
    fill(0);
    text("After taking some time to remember this board, press any key to continue.", width/2, 50);


    fill(0); 
    break; 
  case 1:
    //play state
    text("SCORE: " + streak, width/2, 50);
    text("LIVES: " + (3 - mistakes) + " /3", width/2, 100);
    
    if (colour == 1) {
      text("Select " + (dimension - 1) + " coal ores.", width/2, 200);
      neededtowin = dimension - 1;
    } 
    if (colour == 2) {
      text("Select " + (dimension - 1) + " iron ores.", width/2, 200);
      neededtowin = dimension - 1;
    } 
    if (colour == 3) {
      text("Select all gold ores.", width/2, 200);
      neededtowin = dimension / 2;
    } 
    if (colour == 4) {
      text("Select all diamond ores.", width/2, 200);
      neededtowin = 1;
    }
    gameStateCheck();
    break;
  case 2:
    //win state
    // text("GAMESTATE 2", width/2, 400);

    fill(255, 128, 0); 
    reset();
    break;
  case 3:
    // text("GAMESTATE 3", width/2, 500);

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
  
    // Choosing a random colour for the player to select. 
    colour = new Random().ints(1, 5).distinct().limit(1).toArray()[0];
    streak += 1;
    
    gamestate = -1;
    pressCount = 0; 
    randoms = new Random().ints(0, tileCount).distinct().limit(5 * dimension / 2 + 1).toArray();

    green = Arrays.copyOfRange(randoms, 0, dimension);
    blue = Arrays.copyOfRange(randoms, dimension, 2 * dimension);
    red = Arrays.copyOfRange(randoms, 2 * dimension, 5 * dimension / 2);
    gold = Arrays.copyOfRange(randoms, 5 * dimension / 2, 5 * dimension / 2 + 1);
    
    
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
