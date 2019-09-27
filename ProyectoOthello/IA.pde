/**
* La clase de la I.A del Otello,
* Busca la sigueinte jugada por el algoritmo de minMax
* se trata de una I.A, un agente que intenta resolver su problema por medio de una busqueda
* usa arboles y tablerosCompuestos para el miniMax
* @author ROceloth y su team
*/
class IA {

  Tablero tablero;

  IA(Tablero tab) {
    this.tablero = tab;
  }



  /**
   * Funcion para decidir cual es el siguiente movimento para la IA
   * con la referencia al tablero de la I.A
   * este es un camnino del minimax
   * @return int [] ---> estructura de un arreglo con 2 valores 
   * mov[0] = posX, mov[1] = posY del siguiente movimiento
   */
  int [] nextMove() {

    int profundidad = 3; //dificultad y busqueda en el arbol, a mejorar quiza en el futuro
    Tablero cTablero = tablero.clone(); // cuidado de nunca modificar el tablero original
    TableroCompuesto tc = new TableroCompuesto(cTablero); //Raiz a iniciar

    NTree t = new NTree(tc);
    NTree tree = crearArbolO(t, profundidad);

    int[] coor = miniMax(tree);

    return  coor;
  }


  /**
   * El metodo estrella de la IA, 
   * aqui que se armen los putazos
   * es como un recorrido en dfS
   * pero son las funciones auxiliares de max-V y min-V las que hacen la chamba 
   * porlo tanto esto de aqui es una actualizacion del arbol, en sus nodos, por sus
   * tableros compuestos, en sus valores de H e i, para que al final regrese un indice, el indice
   * de donde llego la jugada ganadora del algoritmo miniMax
   * @param NTree t -- arbol ya generado para aplicar completamente el algoritmo de miniMax
   * @return int[] un arrgle con las coordenadas x, y del siguente movimiento para tirar en el juego del otello
   */
  int [] miniMax(NTree t) {

    //magia recursiva
    int indice = minV(t);
    //recuperemos las coordenadas de la lista de movimientos
    TableroCompuesto a = (TableroCompuesto)t.getDato();
    Tablero c = a.getTablero();
    ArrayList<PVector> m = c.acciones();

    PVector jugada = m.get(indice);
    int posX = (int)jugada.x;
    int posY = (int)jugada.y;
    int [] nextM = {posX, posY};
    return nextM;
  }

  /**
   * funcion de min-Value
   * regresa el valor flotando del menor de las heuristicas segun min y el indice de donde provino tal heuristica
   * @param t NTree
   * @return la burbuja de donde vino con sus valores de utilidad la h y el ri que se actualizan
   */
  int minV(NTree t) {
    //actualizar los estados de valores de las hojas
    if (t.isHoja()) {
      TableroCompuesto tcActual = (TableroCompuesto)t.getDato();
      tcActual.setHeuristica(tcActual.getTablero().heuristica());
      //return los valores de utilidad el valor de la heuristica del tablero compuesto y de donde vino ese indice
      int v = tcActual.getHeuristica(); 
      return v;
    } else {
      int v = 10000; //primer valor de utilidad de min para escoger uno mas chico
      ArrayList<NTree> hijos = t.getHijos();
      for (int i=0; i<hijos.size(); i++) {
        v = Math.min(v, maxV(hijos.get(i)));
      }

      return v;
    }
  }//end min-V

  /**
  * La funcion max-value
  * su gemela de min value, su compa en lo mutuamente recursico, la perra de miniMax (bueno no :v)
  * la funcion para decidir la utilidad mas grande del conjunto de los minimos
  * la el metodo que flota los valores no en el arbol sino es el camino de las llamadas recursivas
  * de los valores de utilidad que nos interesan i.e la h y el i
  * @param Ntree t un arbol de Tableros Compuestos
  * @return la utilidad que al final lo mas util no era el valor de la heuristica sino el indice 
  * que seria la accion de donde vino tal heuristica y con ella poder elegir el siguiente movimiento
  */
  int maxV(NTree t) {
    //actualizar los estados de valores de las hojas
    if (t.isHoja()) {
      TableroCompuesto tcActual = (TableroCompuesto)t.getDato();
      tcActual.setHeuristica(tcActual.getTablero().heuristica());
      //return los valores de utilidad el valor de la heuristica del tablero compuesto y de donde vino ese indice
      int v = tcActual.getHeuristica(); 
      return v;
    } else {

      int v = -10000; //primer valor de utilidad de max para escoger uno mas grande
      ArrayList<NTree> hijos = t.getHijos();
      for (int i=0; i<hijos.size(); i++) {
        v = Math.max(v, minV(hijos.get(i)));
      }
      return v;
    }
  }

/* 
  ¿Porque los 10,000? referencias al 10,000 millones %,
  es la sutitucion de los valores de inicializacion para minV y maxV en el calculo de los minimos del conjunto de los maximos
  y viceversa
*/

  /**
   * Metodo para crear el arbol de busqueda donde actuara el miniMax
   * Preparense para la recursion
   * modifica la raiz para ir creando el arbol de busqueda donde se aplicara el miniMax
   * @param t -- del tipo Arbol de TablerosCompuestos
   * @param int d -- profundidad para crear el arbol
   * @return Ntree -- estructura de arbol ya creada
   */
  NTree crearArbolO(NTree t, int d) {
    TableroCompuesto a = (TableroCompuesto)t.getDato();
    Tablero c = a.getTablero();
    ArrayList<PVector> m = c.acciones(); //algo redundante me salio estas dos
    if (d == 0 || m.isEmpty()) {
      return t;
    } else {
      //obtener el tablero compuesto
      TableroCompuesto actual = (TableroCompuesto)t.getDato();
      //obtener el tablero verdadero
      Tablero act = actual.getTablero();
      //lista de acciones del original
      ArrayList<PVector> moves = act.acciones();
      for (int i=0; i<moves.size(); i++) {
        //casteo de posiciones
        PVector coorA = moves.get(i);
        int x = (int)coorA.x;
        int y = (int)coorA.y;
        //hacemos un clone del original
        Tablero actC = act.clone();
        //cambia de estado
        actC.setFicha(x, y);
        //Se compone de un tableroCompuesto
        TableroCompuesto tabC = new TableroCompuesto(actC);
        //ir actualizando los indices
        tabC.setIndice(i);
        tabC.setRi(i);
        //un arbol de esto
        NTree nA = new NTree(tabC);
        //aplicarle la recursion
        nA = crearArbolO(nA, d-1);
        //añadirlo a la lista de nodos del original
        t.addHijo(nA);
      }//fin de crear los arboles hijos
      return t;
    }//end else
  }
}
