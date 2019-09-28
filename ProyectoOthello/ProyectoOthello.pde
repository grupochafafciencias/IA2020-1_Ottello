/**
 * Proyecto base para el juego de Othello/Reversi
 * @author Rodrigo Colín (La base del proyecto)
 * @author ROceloth (cada vez me gusta mas este nombre)
 */

Tablero tablero;
IA agente;
//Tablero tClone;

/**
 * Método para establecet tamaño de ventana al incluir variables
 */
void settings() {
  tablero =  new Tablero();//8*60 - 8*60
  agente = new IA(tablero); //a su PTM
  size(tablero.dimension * tablero.tamCasilla, tablero.dimension * tablero.tamCasilla);
}

/**
 * Inicializaciones
 */
void setup() {
  println("Proyecto base para el juego de mesa Othello");
}

/**
 * Ciclo de dibujado
 */
void draw() {
  tablero.display();
}

/**
 * Evento para detectar cuando el usuario da clic
 */
void mousePressed() {

  int posX = mouseX/tablero.tamCasilla;
  int posY = mouseY/tablero.tamCasilla;


  if (tablero.validPos(posX, posY) && !tablero.saltaTurno()) { //En este caso el jugador es siempre las negras
    println("\nClic en la casilla " + "[" + posX + ", " + posY + "]");

    //cuando se clikea y no es una posicion correcta de tiro setFicha ignora la accion y pasa
    //al agente su tirada, haciendo parecer que juega por ti
    

    tablero.setFicha(posX, posY);//tiramos siempre negras
    tablero.cambiarTurno();

    //si te equivocas de clik el agente juega por ti XD

    tablero.desplegarStats();

    //tira el agente
    //cuidado que la lista de movimientos no sea vacia sino el algortimo de miniMax de la IA, entraria en un indece inexistente
    //verificar que pueda tirar bien el agente
    if (!tablero.gameOver() && agente.tieneNextM()) {
      int [] agenteMov = agente.nextMove();
      int agPx = agenteMov[0];
      int agPy = agenteMov[1];
      tablero.setFicha(agPx, agPy);
      tablero.cambiarTurno();
      tablero.desplegarStats();
    }

    if (tablero.gameOver()) {
      tablero.endGame();
    }
    //end if verificacion ahogada negra
  } else if(!tablero.estaOcupado(posX, posY) && tablero.saltaTurno()){ 
    tablero.cambiarTurno();
    //un poco de reduncia, pero solo un poco
    if (!tablero.gameOver() && agente.tieneNextM()) { //ahogada blanca?
      int [] agenteMov = agente.nextMove();
      int agPx = agenteMov[0];
      int agPy = agenteMov[1];
      tablero.setFicha(agPx, agPy);
      tablero.cambiarTurno();
      tablero.desplegarStats();
    }else{
      tablero.cambiarTurno();
    }

    if (tablero.gameOver()) {
      tablero.endGame();
    }
  }
}
