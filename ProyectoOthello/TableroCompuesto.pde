class TableroCompuesto{
    Tablero tablero;
    int heuristica;
    int indice;
    
    
    TableroCompuesto(Tablero t, int h, int i){
        this.tablero = t;
        this.heuristica = h;
        this.indice = i;
    }
    
    TableroCompuesto(Tablero t){
      
      this.tablero = t;
      boolean turno = tablero.turno;
      int h = turno? -10000: 10000; //Referecias a piedras
      int i = 0;
      
      this.heuristica = h;
      this.indice = i;
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
