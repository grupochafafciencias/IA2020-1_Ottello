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

    println("\nClic en la casilla " + "[" + posX + ", " + posY + "]");

    //ahora el metodo setFicha esta MAMADISIMO i.e super robusto
    tablero.setFicha(posX, posY);//tiramos siempre negras
    println("Fichas negras " + tablero.fNegras);
    println("Fichas blancas " + tablero.fBlancas);
    println("Heuristica del momento " + ((tablero.turno? "Blancas ": "Negras ")) + tablero.heuristica()); 
    tablero.desplegarStats();

    //tira el agente
    if (!tablero.gameOver()) {
      int [] agenteMov = agente.nextMove();
      int agPx = agenteMov[0];
      int agPy = agenteMov[1];
      tablero.setFicha(agPx, agPy);
    }
  
  //tablero.endGame();
}
