int tablero [][]; //matriz del tablero
int dimension=8;
int casilla=55; //tamaño de la casilla px
boolean turno=true; // Estado del turno del jugador 1 true -> turno player1 false ->turn player2

int fBlancas;
int fNegras;


void setup() {
  
  tablero = new int[dimension][dimension];
  //posicion inicial
  
   tablero[(dimension/2)-1][(dimension/2)-1] = 2;
   tablero[(dimension/2)][(dimension/2)-1] = 1;
   tablero[(dimension/2)][(dimension/2)] = 2;
   tablero[(dimension/2)-1][(dimension/2)] = 1;
   
   fBlancas = 2;
   fNegras = 2;
  
}

//lol
void settings(){
  size(casilla*dimension, casilla*dimension);
}

void draw() {
  for (int i=0; i<dimension; i++) {
    for (int j=0; j<dimension; j++) {
      fill(255);
      rect(i*casilla, j*casilla, casilla, casilla);
      fill(0);
      if (tablero[i][j]==1) { //estas posiciones estan al revez por la forma en que las dibuja partiendo de (x,y) en (0,0) desde la esquina superior izq.
        ellipse((i*casilla)+(casilla/2), (j*casilla)+(casilla/2), casilla*3/5, casilla*3/5);
      } else if (tablero[i][j]==2) {
        fill(255);
        ellipse((i*casilla)+(casilla/2), (j*casilla)+(casilla/2), casilla*3/5, casilla*3/5);
      }
    }
  }
}

void mousePressed() {

  int posX = mouseX/casilla;
  int posY = mouseY/casilla;


  //Areglo de direcciones; en el orden de la funcion
  //0=no, 1=nn, 2=ne, 3=oo, 4=ee, 5=so, 6=ss, 7=se
  boolean [] dir = validMove(posX, posY);
  //para activar la posicion 
  boolean ver = false;
  for (int i=0; i<8; i++) {    
    ver = dir[i] || ver; //esta fue que se pudo clikear y todo el rollo
  }
  print("Turno: ");
  println(turno? "negras": "blancas");

  //pone ficha
  if (ver && tablero[posX][posY] == 0) {
    tablero[posX][posY] = turno? 1: 2;
    actualizar1Ficha();
    //turno = !turno;
  }

  //hace cambios
  for (int i=0; i<dir.length; i++) {
    if (dir[i]) {
      voltearFichas(i, posX, posY);
    }
  }
  
  //cambio de turno
  if(ver){
    turno = !turno;
  }
  println("Posicion clikeada = " + "("+posX+","+posY+")");
  print("Turno siguiente: ");
  println(turno? "negras": "blancas");

  for (int i=0; i<dimension; i++) {
    for (int j=0; j<dimension; j++) {
      print(tablero[j][i]);
    }
    println();
  }
  desplegarFichas();
}

/**
* Idea cuadratica para mostrar fichas
*/
void desplegarFichas(){
  /*
  int b=0, n=0;
  for(int i=0; i<dimension; i++){
    for(int j=0; j<dimension; j++){
      switch(tablero[j][i]){
        case 1:
          n++;
          break;
       case 2:
         b++;
         break;
       default:
         break;
      }
    }
  }
  */
  println("Fichas negras ", fNegras);
  println("Fichas blancas", fBlancas);
}


/**
 * funcion que regresa el valor del siguente turno
 */
int nextTurn() {
  if (turno) {
    return 2;
  } else {
    return 1;
  }
}

/**
 * Funcion que regresa el valor numerico del turno actual
 */
int inTurn() {
  if (turno) {
    return 1;
  } else {
    return 2;
  }
}

/**
 * Revisara los 8 caminos de posiblidades entre uno solo
 * Direcciones
 * no nn ne
 * oo *  ee
 * so ss se
 *
 * return dir [];
 * 0=no, 1=nn, 2=ne, 3=oo, 4=ee, 5=so, 6=ss, 7=se
 */

//se sale en las esquinas y puede tener al lado opuesto un bug
boolean [] validMove(int x, int y) {

  boolean no = false;
  boolean nn = false;
  boolean ne = false;
  boolean oo = false;
  boolean ee = false;
  boolean so = false;
  boolean ss = false;
  boolean se = false;


  //no direccion
  //que no se salga por la diag, arr-izq,
  if ( (x-1 != -1) && (y-1 != -1) && tablero[x-1][y-1]==nextTurn()) {
    for (int j=y-1, i = x-1; j>=0&&i>=0; j--, i--) {
      if (tablero[i][j]== inTurn()) {
        no = true;
        break;
      } else if (tablero[i][j] == 0) {
        no = false;
        break;
      }
    }
  } else {
    no = false;
  }


  //nn direccion 
  //que no salga por arriba
  if (((y-1) != -1) && tablero[x][y-1]==nextTurn()) {
    for (int i=y-1; i>=0; i--) {
      if (tablero[x][i] == inTurn()) {
        nn = true;
        break;
      } else if (tablero[x][i] == 0) {
        nn = false;
        break;
      }
    }
  } else {
    nn = false;
  }


  //ne direction
  //que no se salga por la dig, arr-der
  if ((x+1 != dimension) && (y-1 != -1) && tablero[x+1][y-1]==nextTurn()) {
    for (int j=y-1, i=x+1; j>=0 && i<dimension; j--, i++) {
      if (tablero[i][j]== inTurn()) {
        ne = true;
        //agregar pos;
        break;
      } else if (tablero[i][j] == 0) {
        ne = false;
        break;
      }
    }
  } else {
    ne = false;
  }

  //oo direccion
  //que no salga por la izq.
  if ( ((x-1) != -1) &&  tablero[x-1][y]==nextTurn()) {//la primera tiene que ser contraria solo una vez verificada
    for (int i=x-1; i>=0; i--) {
      if (tablero[i][y] == inTurn()) { //hasta encontrar una del mismo turno
        oo = true;
        break;
      } else if (tablero[i][y] == 0) {
        oo = false;
        break;
      }
    }
  } else {
    oo = false;
  }


  //ee direccion
  //que no se salga por la derecha
  if ((x+1 != dimension) && tablero[x+1][y]==nextTurn()) {
    for (int i=x+1; i<dimension; i++) {
      if (tablero[i][y] == inTurn()) {
        ee = true;
        break;
      } else if (tablero[i][y] == 0) {
        ee = false;
        break;
      }
    }
  } else {
    ee = false;
  }

  //so directiion
  //que no se salga por la diag, abj-izq
  if ((x-1 != -1) && (y+1 != dimension) && tablero[x-1][y+1]==nextTurn()) {
    for (int j=y+1, i=x-1; j<dimension && i>=0; j++, i--) {

      if (tablero[i][j]== inTurn()) {
        so = true;
        //agregar pos;
        break;
      } else if (tablero[i][j] == 0) {
        so = false;
        break;
      }
    }
  } else {
    so = false;
  }

  //ss direccion
  //que no se salga por abajo
  if (((y+1) != dimension) && tablero[x][y+1]==nextTurn()) {
    for (int i=y+1; i<dimension; i++) {

      if (tablero[x][i] == inTurn()) {
        ss = true;
        break;
      } else if (tablero[x][i] == 0) {
        ss = false;
        break;
      }
    }
  } else {
    ss = false;
  }

  //se directiion
  //que no se salga por la diagonal abj-der
  if ((x+1 != dimension) && (y+1 != dimension) && tablero[x+1][y+1]==nextTurn()) {
    for (int j=y+1, i=x+1; j<dimension && i<dimension; j++, i++) {
      if (tablero[i][j]== inTurn()) {
        se = true;
        //agregar pos;
        break;
      } else if (tablero[i][j] == 0) {
        se = false;
        break;
      }
    }
  } else {
    se = false;
  }

  boolean dir [] = {no, nn, ne, oo, ee, so, ss, se};
  
  return dir;
}


/**
 * Funcion para voltear fichas, es como una funcion privada
 * ya que se debe de llamar con la direccion y posicion ya verificada, para que las especializadas sean seguras
 * Direcciones
 * no nn ne
 * oo *  ee
 * so ss se
 * dir:
 * 0=no, 1=nn, 2=ne, 3=oo, 4=ee, 5=so, 6=ss, 7=se
 *
 * En el la posicion inicial [x][y]
 *
 * siguendo su posicion volteara las de enmendio del otro color 
 */
void voltearFichas(int dir, int x, int y) {
  switch(dir) {
  case 0:
    volFicNO(x, y);
    break;
  case 1:
    volFicNN(x, y);
    break;
  case 2:
    volFicNE(x, y);
    break;
  case 3:
    volFicOO(x, y);
    break;
  case 4:
    volFicEE(x, y);
    break;
  case 5:
    volFicSO(x, y);
    break;
  case 6:
    volFicSS(x, y);
    break;
  case 7:
    volFicSE(x, y); //Todas esta mini funciones ya tienen claro su direccion
    break;
  }
}

// Funciones ya con sus direcciones, realmente empiezan en la pos siguiente segun su direccion
// Aqui si actualizan cuantas fichas hay de cada uno


/**
* Para los cambios parciales, en automatico con el volteado de fichas
*/
void miniCambio(int cam){
  if(turno){//fueron las negras
    fNegras += cam;
    fBlancas -= cam;
  }else{
    fBlancas += cam;
    fNegras -= cam;
  }
}

/**
* Solo una vez que se coloco una nueva ficha
*/
void actualizar1Ficha(){
  if(turno){
    fNegras++;
  }else{
    fBlancas++;
  }
}

/**
 * 0
 * Cambia fichas hacia la direcion no
 */
void volFicNO(int x, int y) {
  int cam = 0;
  for (int i=x-1, j=y-1; i>=0&&j>=0; i--, j--) {
    //cambio
    tablero[i][j] = inTurn();
    cam++;
    //ver la siguiente pos
    if (tablero[i-1][j-1]==inTurn()) {
      break; //se acabo
    }
  }
  miniCambio(cam);
}

/**
 * 1
 * Cambia fichas hacia la direcion nn
 */
void volFicNN(int x, int y) {
  int cam = 0;
  for (int i=y-1; i>=0; i--) {
    //cambio
    tablero[x][i] = inTurn();
    cam++;
    //next
    if (tablero[x][i-1]==inTurn()) {
      break;
    }
  }
  miniCambio(cam);
}

/**
 * 2
 * Cambia fichas hacia la direcion ne
 */
void volFicNE(int x, int y) {
  int cam=0;
  for (int i=x+1, j=y-1; i<dimension&&j>=0; i++, j--) {
    //cambio
    tablero[i][j] = inTurn();
    cam++;
    //ver la siguiente pos
    if (tablero[i+1][j-1]==inTurn()) { //todas las funciones ya tienen un tope y aqui si entra es ese tope
      //(x,y)----(tablero[][]) entra en estos if
      break; //se acabo
    }
  }
  miniCambio(cam);
}

/**
 * 3
 * Cambia fichas hacia la direcion oo
 */
void volFicOO(int x, int y) {
  int cam=0;
  for (int i=x-1; i>=0; i--) {
    //cambio
    tablero[i][y] = inTurn();
    cam++;
    //next
    if (tablero[i-1][y]==inTurn()) {
      break;
    }
  }
  miniCambio(cam);
}

/**
 * 4
 * Cambia fichas hacia la direcion ee
 */
void volFicEE(int x, int y) {
  int cam=0;
  for (int i=x+1; i<dimension; i++) {
    //cambio
    tablero[i][y] = inTurn();
    cam++;
    //next
    if (tablero[i+1][y]==inTurn()) {
      break;
    }
  }
  miniCambio(cam);
}

/**
 * 5
 * Cambia fichas hacia la direcion so
 */
void volFicSO(int x, int y) {
  int cam=0;
  for (int i=x-1, j=y+1; i>=0&&j<dimension; i--, j++) {
    //cambio
    tablero[i][j] = inTurn();
    cam++;
    //ver la siguiente pos
    if (tablero[i-1][j+1]==inTurn()) {
      break; //se acabo
    }
  }
  miniCambio(cam);
}

/**
 * 6
 * Cambia fichas hacia la direcion ss
 */
void volFicSS(int x, int y) {
  int cam=0;
  for (int i=y+1; i<dimension; i++) {
    tablero[x][i]=inTurn();
    cam++;
    //ver next
    if (tablero[x][i+1]==inTurn()) {
      break;
    }
  }
  miniCambio(cam);
}

/**
 * 7
 * Cambia fichas hacia la direcion se
 */
void volFicSE(int x, int y) {
  int cam=0;
  for (int i=x+1, j=y+1; i<dimension&&j<dimension; i++, j++) {
    //cambio
    tablero[i][j] = inTurn();
    cam++;
    //ver la siguiente pos
    if (tablero[i+1][j+1]==inTurn()) {
      break; //se acabo
    }
  }
  miniCambio(cam);
}
