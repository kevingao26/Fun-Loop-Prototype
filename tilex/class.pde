class Tile {
  int tilestate, xpos, ypos, count; 
  Tile(int x, int y, int s) {
    xpos = x; 
    ypos = y; 
    tilestate = s;
    count = 0; 
  }
  void show() {
    switch(tilestate) {
    case 0:
      image(img[0], xpos, ypos, tileSize, tileSize);
      break;
    case 1:
      image(img[1], xpos, ypos, tileSize, tileSize);
      break;
    case 2:
      image(img[2], xpos, ypos, tileSize, tileSize);
      break;
    case 3:
      image(img[3], xpos, ypos, tileSize, tileSize);
      break;
    case 4:
      image(img[4], xpos, ypos, tileSize, tileSize);
      break;
    case 5:
      image(img[5], xpos, ypos, tileSize, tileSize);
      break;
    case 6:
      image(img[6], xpos, ypos, tileSize, tileSize);
      break;
    case 7:
      image(img[7], xpos, ypos, tileSize, tileSize);
      break;
    case 8:
      image(img[8], xpos, ypos, tileSize, tileSize);
      break;
    case 9:
      image(img[9], xpos, ypos, tileSize, tileSize);
      break;
    }
  }
}
