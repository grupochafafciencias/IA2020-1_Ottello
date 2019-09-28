/**
 * Proyecto base para el juego de Othello/Reversi
 * @author Rodrigo Colín (La base del proyecto)
 * @ROceloth (cada vez me gusta mas este nombre)
 */

Tablero tablero;
IA agente;
//Tablero tClone;

/**
 * Método para establecet tamaño de ventana al incluir variables
 */
void settings(){
  tablero =  new Tablero();//8*60 - 8*60
  agente = new IA(tablero);
  size(tablero.dimension * tablero.tamCasilla, tablero.dimension * tablero.tamCasilla);
}

/**
 * Inicializaciones
 */
void setup(){
  println("Proyecto base para el juego de mesa Othello");
}

/**
 * Ciclo de dibujado
 */
void draw(){
  tablero.display();
}

/**
 * Evento para detectar cuando el usuario da clic
 */
void mousePressed() {
  
  int posX = mouseX/tablero.tamCasilla;
  int posY = mouseY/tablero.tamCasilla;
  
  println("\nClic en la casilla " + "[" + posX + ", " + posY + "]");
  /*
  if(!tablero.estaOcupado(posX, posY)){ //La logica sigue siendo aqui tipo main
    tablero.setFicha(posX, posY); //este metodo implicaba variaas cosas
    tablero.cambiarTurno();  //solo si fue una tirada valida
    println("[Turno #" + tablero.numeroDeTurno + "] "  + (tablero.turno ? "jugó ficha blanca" : "jugó ficha negra") + 
    " (Score: " + int(tablero.cantidadFichas().x) + " - " + int(tablero.cantidadFichas().y) + ")");
  }*/
   
  
  //ahora el metodo setFicha esta MAMADISIMO i.e super robusto
  tablero.setFicha(posX, posY);//tiramos siempre negras
  println("Fichas negras " + tablero.fNegras);
  println("Fichas balncas " + tablero.fBlancas);
  println("Heuristica del momento " + ((tablero.turno? "Blancas ": "Negras ")) + tablero.heuristica()); 
  tablero.desplegarStats();
  
  //tira el agente
  int [] agenteMov = agente.nextMove();
  int agPx = agenteMov[0];
  int agPy = agenteMov[1];
  tablero.setFicha(agPx,agPy);
  
   //Test clone
  /*
  if(tablero.numeroDeTurno == 2){
     tClone = tablero.clone();
  }
  //revision
  if(tablero.numeroDeTurno == 4){
    println("El clone tiene como matriz:");
    for(int i=0; i<tClone.dimension; i++){
      for(int j=0; j<tClone.dimension; j++){
        print(tClone.mundo[j][i]);
      }
      println();
    }
    print(tClone.heuristica());
  }*/
  
}
