import java.util.Iterator;


/**
 * Definición de un tablero para el juego de Othello
 * @author Rodrigo Colín (La base)
 * @ROceloth
 */
class Tablero {
  /**
   * Cantidad de casillas en horizontal y vertical del tablero
   */
  int dimension;

  /**
   * El tamaño en pixeles de cada casilla cuadrada del tablero
   */
  int tamCasilla;

  /**
   * Representación lógica del tablero. El valor númerico representa:
   * 0 = casilla vacia
   * 1 = casilla con ficha del primer jugador
   * 2 = casilla con ficha del segundo jugador
   */
  int[][] mundo;

  /**
   * Representa de quién es el turno bajo la siguiente convención:
   * true = turno del jugador 1
   * false = turno del jugador 2
   */
  boolean turno;

  /**
   * Contador de la cantidad de turnos en el tablero
   */
  int numeroDeTurno;

  /**
   * numero de fichas negras y blancas, directamente como contador 
   * para aplicar mas rapido la heuristica
   */
  int fNegras, fBlancas; 


  /**
   * Constructor base de un tablero. 
   * @param dimension Cantidad de casillas del tablero, comúnmente ocho.
   * @param tamCasilla Tamaño en pixeles de cada casilla
   */
  Tablero(int dimension, int tamCasilla) {
    this.dimension = dimension;
    this.tamCasilla = tamCasilla;
    turno = true;
    numeroDeTurno = 0;
    mundo = new int[dimension][dimension];
    // Configuración inicial (colocar 4 fichas al centro del tablero):, estado inicial
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = 2;
    mundo[dimension/2][dimension/2] = 2;

    //conteo directo en los cambios
    this.fNegras = 2;
    this.fBlancas = 2;
  }

  /**
   * Constructor por default de un tablero con las siguientes propiedades:
   * Tablero de 8x8 casillas, cada casilla de un tamaño de 60 pixeles,
   */
  Tablero() {
    this(8, 60);
  }

  /**
   * Construtor completo para los clones
   * @param int d, dimension
   * @param int tamC, tamaño de la casilla
   , @param boolean t, turno 
   * @int numT,  numero de turno 
   * @param int[][] m,  mundo
   * @int fn, fichas negras
   * @param int fb, fichas blancas
   */
  Tablero(int d, int tamC, boolean t, int numT, int[][] m, int fn, int fb) {
    this.dimension = d;
    this.tamCasilla = tamC;
    this.turno = t;
    this.numeroDeTurno = numT;
    this.mundo = m; //cuidado de no pasar una referencia
    this.fNegras = fn;
    this.fBlancas = fb;
  }

  /**
   * Dibuja en pantalla el tablero, es decir, dibuja las casillas y las fichas de los jugadores
   */
  void display() {
    color fondo = color(63, 221, 24); // El color de fondo del tablero
    color linea = color(0); // El color de línea del tablero
    int grosor = 2; // Ancho de línea (en pixeles)
    color jugador1 = color(0); // Color de ficha para el primer jugador
    color jugador2 = color(255); // Color de ficha para el segundo jugador

    // Doble iteración para recorrer cada casilla del tablero
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        // Dibujar cada casilla del tablero:
        fill(fondo); // establecer color de fondo
        stroke(linea); // establecer color de línea
        strokeWeight(grosor); // establecer ancho de línea
        rect(i*tamCasilla, j*tamCasilla, tamCasilla, tamCasilla);

        // Dibujar las fichas de los jugadores:
        if (mundo[i][j] != 0 && (mundo[i][j] == 1 || mundo[i][j] == 2)) { // en caso de que la casilla no esté vacia
          fill(mundo[i][j] == 1 ? jugador1 : jugador2); // establecer el color de la ficha
          noStroke(); // quitar contorno de línea
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*3/5, tamCasilla*3/5);
        }
      }
      
  }

  /**
   * Coloca o establece una ficha en una casilla específica del tablero.
   * Nota: El eje vertical está invertido y el conteo empieza en cero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * @param turno Representa el turno o color de ficha a establecer
   */
  void setFicha(int posX, int posY, boolean turno) {
    mundo[posX][posY] = turno ? 1 : 2;  //lol, y esta funcion privada con la otra solo por una linea para darle vueltas
  }//no necesitaremos mas de esta sobrecarga

  // de aqui en adelante la logica de los turnos

  /**
   * Coloca o establece una ficha en una casilla específica del tablero segun el turno del tablero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * Mas aparte, este metodo tienen toda la logica involucrada para colocar correctamente una ficha y las consecuencias que
   * implica esto, haciendo una cascada de metodos
   */
  void setFicha(int posX, int posY) { 
    //this.setFicha(posX, posY, this.turno); //pero turno ya es variable de la clase y siempre es accesible dentro de esta
    //verificar que el jugador en turno puede tirar, NOTA: a mejorar en posiciones doblemente ahogadas
    if (saltaTurno()) {
      println("Se salta en turno de " + (turno? "Negras": "Blancas"));
      turno = !turno; //realmente no avanza en turno el juego
    }
        
    //Areglo de direcciones; en el orden de la funcion
    //0=no, 1=nn, 2=ne, 3=oo, 4=ee, 5=so, 6=ss, 7=se
    boolean [] dir = validMoves(posX, posY);
    //para activar la posicion 
    boolean ver = false;
    for (int i=0; i<8; i++) {    
      ver = dir[i] || ver; //esta fue que se pudo clikear y todo el rollo
    }

    //pone ficha
    //mundo[posX][posY] == 0
    if (ver && !estaOcupado(posX, posY)) {
      mundo[posX][posY] = turno? 1: 2;
      actualizar1Ficha();

      //hacer cambios
      voltearFichas(dir, posX, posY);
    }

    //cambio de turno, fue un turno valido
    if (ver) {
      cambiarTurno();
    }
    //println("Posicion clikeada = " + "("+posX+","+posY+")");
    print("Turno siguiente: ");
    println(turno? "negras": "blancas");
    //desplegarFichas(); -> desplegarStats
    
    //posiciones validas ? solo chequeo
    println("Posiciones validas para " +(turno? "Negras": "Blancas") );
    ArrayList<PVector> actions = tablero.acciones();
    tablero.displayListaAcciones(actions);
    
  }//end setFicha

  /**
   * Para que el despliegue de fichas no sea cuadratico,
   * desplegar la informacion del juego en ese estado del mundo(matriz del otello)
   * En un despliegue de quien fue el ultimo que jugo
   */
  void desplegarStats() {
    println("[Turno #" + tablero.numeroDeTurno + "] "  + (tablero.turno? "jugó ficha blanca" : "jugó ficha negra") + 
      " (Score: " + fNegras + " - " + fBlancas + ")");
  }

  /**
   * Representa el cambio de turno. Normalmente representa la última acción del turno
   */
  void cambiarTurno() {
    turno = !turno;
    numeroDeTurno += 1; //actualizacion del contador
  }

  /**
   * Verifica si en la posición de una casilla dada existe una ficha (sin importar su color)
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @return True si hay una ficha de cualquier color en la casilla, false en otro caso
   */
  boolean estaOcupado(int posX, int posY) {
    return mundo[posX][posY] != 0;
  }

  /**
   * Cuenta la cantidad de fichas de un jugador
   * @return La cantidad de fichas de ambos jugadores en el tablero como vector, 
   * donde x = jugador1, y = jugador2
   */
  PVector cantidadFichas() { //Este metodo ya no es necesario
    PVector contador = new PVector();
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        if (mundo[i][j] == 1)
          contador.x += 1;
        if (mundo[i][j] == 2)
          contador.y += 1;
      }
    return contador;
  }

  //Antes Funciones, ahora es una metodo de esta clase

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
   * @param x -- PosX
   * @param y -- PosY
   * return dir [];
   * 0=no, 1=nn, 2=ne, 3=oo, 4=ee, 5=so, 6=ss, 7=se
   */

  boolean [] validMoves(int x, int y) {

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
    if ( (x-1 != -1) && (y-1 != -1) && mundo[x-1][y-1]==nextTurn()) {
      for (int j=y-1, i = x-1; j>=0&&i>=0; j--, i--) {
        if (mundo[i][j]== inTurn()) {
          no = true;
          break;
        } else if (mundo[i][j] == 0) {
          no = false;
          break;
        }
      }
    } else {
      no = false;
    }


    //nn direccion 
    //que no salga por arriba
    if (((y-1) != -1) && mundo[x][y-1]==nextTurn()) {
      for (int i=y-1; i>=0; i--) {
        if (mundo[x][i] == inTurn()) {
          nn = true;
          break;
        } else if (mundo[x][i] == 0) {
          nn = false;
          break;
        }
      }
    } else {
      nn = false;
    }

    //ne direction
    //que no se salga por la dig, arr-der
    if ((x+1 != dimension) && (y-1 != -1) && mundo[x+1][y-1]==nextTurn()) {
      for (int j=y-1, i=x+1; j>=0 && i<dimension; j--, i++) {
        if (mundo[i][j]== inTurn()) {
          ne = true;
          //agregar pos;
          break;
        } else if (mundo[i][j] == 0) {
          ne = false;
          break;
        }
      }
    } else {
      ne = false;
    }

    //oo direccion
    //que no salga por la izq.
    if ( ((x-1) != -1) &&  mundo[x-1][y]==nextTurn()) {//la primera tiene que ser contraria solo una vez verificada
      for (int i=x-1; i>=0; i--) {
        if (mundo[i][y] == inTurn()) { //hasta encontrar una del mismo turno
          oo = true;
          break;
        } else if (mundo[i][y] == 0) {
          oo = false;
          break;
        }
      }
    } else {
      oo = false;
    }


    //ee direccion
    //que no se salga por la derecha
    if ((x+1 != dimension) && mundo[x+1][y]==nextTurn()) {
      for (int i=x+1; i<dimension; i++) {
        if (mundo[i][y] == inTurn()) {
          ee = true;
          break;
        } else if (mundo[i][y] == 0) {
          ee = false;
          break;
        }
      }
    } else {
      ee = false;
    }

    //so directiion
    //que no se salga por la diag, abj-izq
    if ((x-1 != -1) && (y+1 != dimension) && mundo[x-1][y+1]==nextTurn()) {
      for (int j=y+1, i=x-1; j<dimension && i>=0; j++, i--) {

        if (mundo[i][j]== inTurn()) {
          so = true;
          //agregar pos;
          break;
        } else if (mundo[i][j] == 0) {
          so = false;
          break;
        }
      }
    } else {
      so = false;
    }

    //ss direccion
    //que no se salga por abajo
    if (((y+1) != dimension) && mundo[x][y+1]==nextTurn()) {
      for (int i=y+1; i<dimension; i++) {

        if (mundo[x][i] == inTurn()) {
          ss = true;
          break;
        } else if (mundo[x][i] == 0) {
          ss = false;
          break;
        }
      }
    } else {
      ss = false;
    }

    //se directiion
    //que no se salga por la diagonal abj-der
    if ((x+1 != dimension) && (y+1 != dimension) && mundo[x+1][y+1]==nextTurn()) {
      for (int j=y+1, i=x+1; j<dimension && i<dimension; j++, i++) {
        if (mundo[i][j]== inTurn()) {
          se = true;
          //agregar pos;
          break;
        } else if (mundo[i][j] == 0) {
          se = false;
          break;
        }
      }
    } else {
      se = false;
    }

    boolean dir [] = {no, nn, ne, oo, ee, so, ss, se};

    return dir;
  }//end validMoves()

  //seccion de volteado

  void voltearFichas(boolean [] dir, int posX, int posY) {
    for (int i=0; i<dir.length; i++) {
      if (dir[i]) {
        voltearFichas(i, posX, posY);
      }
    }
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
  void miniCambio(int cam) {
    if (turno) {//fueron las negras
      fNegras += cam;
      fBlancas -= cam;
    } else {
      fBlancas += cam;
      fNegras -= cam;
    }
  }

  /**
   * Solo una vez que se coloco una nueva ficha
   */
  void actualizar1Ficha() {
    if (turno) {
      fNegras++;
    } else {
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
      mundo[i][j] = inTurn();
      cam++;
      //ver la siguiente pos
      if (mundo[i-1][j-1]==inTurn()) {
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
      mundo[x][i] = inTurn();
      cam++;
      //next
      if (mundo[x][i-1]==inTurn()) {
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
      mundo[i][j] = inTurn();
      cam++;
      //ver la siguiente pos
      if (mundo[i+1][j-1]==inTurn()) { //todas las funciones ya tienen un tope y aqui si entra es ese tope
        //(x,y)----(mundo[][]) entra en estos if
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
      mundo[i][y] = inTurn();
      cam++;
      //next
      if (mundo[i-1][y]==inTurn()) {
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
      mundo[i][y] = inTurn();
      cam++;
      //next
      if (mundo[i+1][y]==inTurn()) {
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
      mundo[i][j] = inTurn();
      cam++;
      //ver la siguiente pos
      if (mundo[i-1][j+1]==inTurn()) {
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
      mundo[x][i]=inTurn();
      cam++;
      //ver next
      if (mundo[x][i+1]==inTurn()) {
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
      mundo[i][j] = inTurn();
      cam++;
      //ver la siguiente pos
      if (mundo[i+1][j+1]==inTurn()) {
        break; //se acabo
      }
    }
    miniCambio(cam);
  }

  //Salto de turno por hay una posicion aogada
  //tiene que encontrar que almenos hay una tirada para el jugador en turno
  boolean saltaTurno() {
    boolean salto = false;
    for (int i=0; i<dimension; i++) {
      for (int j=0; j<dimension; j++) {
        if (mundo[j][i]==0) {
          //comprovamos
          boolean dir[] =  validMoves(j, i);
          boolean ver = false;
          for (int k=0; k<dir.length; k++) {
            ver = ver || dir[k];
          }
          salto = salto || ver;
          if (salto) { //hubo una valida
            break;
          }
        }
      }
    }
    return !salto;
  }//end saltaTurno

  //si es como en java seria que regresa un Object, pero simplifiquemos las cosas
  Tablero clone() {
    //copia de su matriz del mundo
    int cMundo[][] = new int [this.dimension][this.dimension];
    for (int i=0; i<this.dimension; i++) {
      for (int j=0; j<this.dimension; j++) {
        cMundo[j][i] = this.mundo[j][i];
      }
    }

    Tablero clone = new Tablero(this.dimension, this.tamCasilla, this.turno, this.numeroDeTurno, 
      cMundo, this.fNegras, this.fBlancas);

    return clone;
  }

  //heuristica chafona
  /**
   * con respecto al jugador, para el minimax
   * la de maximizacion en ese momento 
   * la diferencia de fichas con respecto al turno anterior del juego
   * quien ve la evaluacion de su jugada cuando pone la ficha, para tomar una decision
   * NOTA el turno se voltea por los cambios de turno y la forma en que evalua la tirada
   */
  int heuristica() {
    return turno? fBlancas-fNegras: fNegras-fBlancas;
  }

  /**
   * Genera la lista de posibles acciones a ejecutar 
   * @return ArrayList de coordenadas (x,y) para la matriz que son posiciones validas para tirar
   */
  ArrayList<PVector> acciones() {

    ArrayList<PVector> listPos = new ArrayList();
    for (int i=0; i<dimension; i++) {
      for (int j=0; j<dimension; j++) {
        //verificar posicion
        if (mundo[j][i] == 0) { //para que solo busque donde esta libre 
          boolean [] dir = validMoves(j, i);
          boolean ver = false;
          for (int k=0; k<8; k++) {    
            ver = dir[k] || ver; //para resumir si es una posicion valida
          }

          if (ver) {//fue una posicion valida
            PVector pos = new PVector(j, i);
            listPos.add(pos);
          }
        }
      }
    }
    return listPos;
  }
  
  /**
  * auxiliar para desplegar la lista de posiciones
  */
  void displayListaAcciones(ArrayList<PVector> l){
    print("{ ");
    Iterator<PVector> iterator = l.iterator();
    while(iterator.hasNext()){
      PVector v = iterator.next();
      print("(" + v.x + "," + v.y + (iterator.hasNext()? "), ": ")"));
    }
    println("}");
  }
  
  /**
  * Metodo para saber cuando termino el juego
  * En teoria hay 3 casos:
  * 1.-Cuando las fichaas sumas fNegras+fBlancas = 64
  * 2.-Cuando alguna de las dos es cero
  * 3.-Cuando hay una posicion doblente ahogada
  * @return la logica de esos 3 casos
  */
  boolean gameOver(){
    if(fNegras + fBlancas == dimension*dimension){
      return true;
    }
    
    if(fNegras == 0 || fBlancas == 0){
      return true;
    }
    
    boolean caso3 = dobleAhogada();
    if(caso3){
      return true;
    }
    return false;
  }
  
  /**
  * Verifiquemos una doble ahogada con un solo turno
  */
  boolean dobleAhogada(){
    Tablero tabC = tablero.clone();
    tabC.setTurno(!tabC.getTurno()); //cambio de turno del clon
    
    ArrayList acc1 = acciones();
    ArrayList acc2 = tabC.acciones(); //acciones del siguiente jugador clon
    return acc1.isEmpty() && acc2.isEmpty(); 
  }
  
  /**
  * despliega en unn chasquido de dedos
  * quien gano o si hubo empate
  */
  void endGame(){
    if(fBlancas == fNegras){
    println("Empate");
    }else{
      println("Ganan las " + ((fNegras > fBlancas)? "Negras": "Blancas"));
    }
  }
  
  void setTurno(boolean turno){
    this.turno=turno;
  }
  
  boolean getTurno(){
    return turno;
  }
}//end class Tablero
