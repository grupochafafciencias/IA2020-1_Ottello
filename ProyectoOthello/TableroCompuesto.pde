

/**
* Clase de un objeto compuesto para el arbol 
* donde se aplicara minimax, el proposito de esta clase sera 
* en recordar en el minimax, que dado el ganador de su heuristica, 
* saber de que hijo probino para poder elejir la siguiente accion
*/
class TableroCompuesto{
    Tablero tablero;
    int heuristica; //valor heuristico (de utilidad)
    int indice; // indice donde proviene sus hijos
    int ri;  //copia de acareo de un indice
    
    /*La heuristica y el ri, iran flotando por los objetos en el algoritmo
    miniMax, la heuristica solo flotara y se acuatizaran en los nodos intermedios, e 
    ri se ira acutailzado segun el indice para recordar que provimo de ese hijo*/
    
    TableroCompuesto(Tablero t, int h, int i){
        this.tablero = t;
        this.heuristica = h;
        this.indice = i;
    }
    
    TableroCompuesto(Tablero t){
      
      this.tablero = t;
      /* la heusitica inicializada depende del arbol
      boolean turno = tablero.turno;
      int h = turno? -10000: 10000; //Referecias a piedras
      */
      
      this.heuristica = 0;
      this.indice = 0;
      this.ri = -1;
    }
    
    
    Tablero getTablero(){
      return tablero;
    }
    
    int getRi(){
      return ri;
    }
    
    void setRi(int ri){
      this.ri = ri;
    }
    
    int getIndice(){
      return indice;
    }
    
    void setIndice(int i){
      this.indice = i;
    }
    
    int getHeuristica(){
      return heuristica;
    }
    
    void setHeuristica(int h){
      this.heuristica = h;
    }
    
  
  }
