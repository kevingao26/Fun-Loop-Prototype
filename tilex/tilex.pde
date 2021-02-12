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

int round = 0;
int[] randoms = new Random().ints(0, tileCount).distinct().limit(round).toArray();

int pressCount = 0; 

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
    if (t[tileNumber].tilestate != 0) {
      pressCount++;
      dingSound.play();
      t[tileNumber].tilestate = 0;
    }
    println(pressCount, round);
  }
}

void gameStateCheck() {
  //win condition 

  if (pressCount == round) {
    //end win condition 
    gamestate = 2;
  }
}

void gameState () {
  switch(gamestate) {
  case 0:
    textFont(Freight); 
    textAlign(CENTER);
    fill(0); 
    break; 
  case 1:
    //play state
    gameStateCheck();
    break;
  case 2:
    //win state
    textFont(Freight); 
    textAlign(CENTER);
    fill(255, 128, 0); 
    reset();
    break;
  }
}

void reset() {
  
    if (round == dimension * dimension) {
      round = 0;
      // TODO: Insert sound effect
    }
    gamestate = 0;
    pressCount = 0; 
    round += 1;
    randoms = new Random().ints(0, tileCount).distinct().limit(round).toArray();
    for (int j = 0; j <tileCount; j++) {
      boolean in_random = false;
      for (int k = 0; k < round; k++) {
          if (j == randoms[k]) {
            in_random = true;
          }
      }
      if (in_random == false) {
        t[j].tilestate = 0;
      } else {
        t[j].tilestate = (new Random().ints(1, 5).distinct().limit(1).toArray())[0];
      }
    }
}
//rules
