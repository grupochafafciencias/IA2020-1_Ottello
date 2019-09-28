/**
* Clase para representar un objeto de valor de utilidad
* para el algoritmo de minimax, y asi saber de que hijo provino dada
* de su heuristica ganadora que fue flotando por el arbol de busqueda
* esta burbuja guarda la informacion de utilidad
* @author ROceloth team
* @version 1.0
*/
static class Burbuja{
  int h; //valor para guardar la heuristica/utilidad
  int i; //valor para subir en el arbol, el recorido de minV y maxV lo especifica
  int ri; //para guardar el indice del hijo del que vino la heuristica
  
  Burbuja(int h, int i, int ri){
    this.h=h;
    this.i=i;
    this.ri=ri;
  }
  
  //Overchansu
  Burbuja(){
    this(0,-1,-1);
  }
  
  //accesos y esos
  
  int getRi(){
    return ri;
  }
  
  void setRi(int ri){
    this.ri=ri;
  }
  
  int getH(){
    return h;
  }
  
  void setH(int h){
    this.h=h;
  }
  
  int getI(){
    return i;
  }
  
  void setI(int i){
    this.i=i;
  }
  
  /*
    El valor del indice de las burbujas debe construirse deacuerdo al arbol
  */
  
  /**
  * Un metodo que hara dos cosas dedicir que burbuja tienen la h mas grande
  * y regresar tal burbuja,
  * para adecuarlo ala modificacion del algotimo de miniMax
  * @param Burubuja b1 -- una burbuja
  * @param Burbuja b2 -- otra burbuja a comparar
  * @return Burbuja, la que tiene la h mas grande con el nuevo indice
  */
  static Burbuja maximaB(Burbuja b1, Burbuja b2){
    if(b1.getH() >= b2.getH()){
      return b1;
    }else{
      return b2;
    }
  }
  
 
 //metodos para una comparacion rapida en el chequeo
  static boolean mayorB(Burbuja b1, Burbuja b2){    
    return b1.getH() > b2.getH() ;
  }
  
  static boolean menorB(Burbuja b1, Burbuja b2){    
    return b1.getH() < b2.getH() ;
  }
  
  /**
  * Un metodo que hara dos cosas dedicir que burbuja tienen la h mas pequeña
  * y regresar tal burbuja, 
  * para adecuarlo ala modificacion del algotimo de miniMax
  * @param Burubuja b1 -- una burbuja
  * @param Burbuja b2 -- otra burbuja a comparar
  * @return Burbuja, la que tiene la h mas pequeña con el nuevo indice
  */
  static Burbuja minimaB(Burbuja b1, Burbuja b2){
    if(b1.getH() <= b2.getH()){
      return b1;
    }else{
      return b2;
    }
  }
  
}
