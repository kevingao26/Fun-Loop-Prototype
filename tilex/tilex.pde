import java.util.*;
import java.util.Set;

//Dimension
int dimension = 6;
int tileCount = dimension*dimension; 
int tileSize = 0; 
int stateCount = 10; 
int permutations = int(pow(2, tileCount)); 
int gamestate = 2; 
int replayvalue = 0; 
PFont Freight; 

int round = 0;
int[] randoms = new Random().ints(0, tileCount).distinct().limit(round).toArray();

int pressCount = 0; 

PImage img[] = new PImage[stateCount]; 
Tile t[] = new Tile[tileCount]; 

void setup() {
  Freight = loadFont("FreightDispProBlack-Regular-60.vlw"); 
  //println(randoms);
  //println ("possible permutations: = "+permutations); 
  size(1024, 1024);
  tileSize = width/dimension;
  for (int i = 0; i <stateCount; i++) {
    img[i] = loadImage(i+".jpg");
  }
  for (int j = 0; j <tileCount; j++) {
    t[j] = new Tile((j%dimension)*tileSize, (j/dimension)*tileSize, 0);
  }
}
void draw() {
  background(0); 
  for (int s = 0; s <tileCount; s++) {
    t[s].show();
  }
  gameState();
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
    //text ("Select the secret tile to win!", width/2, height/2+20); 
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
    //text ("PTS: "+pressCount, width/2, height/2+20);
    //text ("Press Zero to play again", width/2, height/2+178);
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
      //reset the game
      if (in_random == false) {
        t[j].tilestate = 0;
      } else {
        t[j].tilestate = (new Random().ints(1, 5).distinct().limit(1).toArray())[0];
      }
      
    }
    
    
}
//rules
