import 

class IA{

  Tablero tablero;
  
  IA(Tablero tab){
    this.tablero = tab;
  }
  
  
  
  
  int [] nextMove(){
    
    
    int profundidad = 5; //dificultad y busqueda en el arbol
    Tablero cTablero = tablero.clone();
    TableroCompuesto tc = new TableroCompuesto(cTablero); //Raiz a iniciar
    
    Nodo raiz = new Nodo(tc);
    
    NTree tree = new NTree(raiz);
    
    int[] coor = miniMax(tree, profundidad);
    
    return  coor;
    
  }
  
  
  /**
  * El metodo estrella de la IA, 
  * aqui que se armen los putazos
  */
  int [] miniMax(NTree t, int d){
    
  }
  
}
