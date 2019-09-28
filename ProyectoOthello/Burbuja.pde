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
  int i; //para guardar el indice del hijo del que vino la heuristica
  
  Burbuja(int h, int i){
    this.h=h;
    this.i=i;
  }
  
  //Overchansu
  Burbuja(){
    this(0,-1);
  }
  
  //accesos y esos
  
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
  
  
  /**
  * Un metodo que hara dos cosas dedicir que burbuja tienen la h mas grande
  * y regresar tal burbuja, al mismo tiempo que modifica el otro valor indice de la burbuja
  * para adecuarlo ala modificacion del algotimo de miniMax
  * @param Burubuja b1 -- una burbuja
  * @param Burbuja b2 -- otra burbuja a comparar
  * @param int i -- el nuevo indice a modificar en la burbuja ganadora
  * @return Burbuja, la que tiene la h mas grande con el nuevo indice
  */
  static Burbuja maximaB(Burbuja b1, Burbuja b2, int i){
    if(b1.getH() >= b2.getH()){
      b1.setI(i);
      return b1;
    }else{
      b2.setI(i);
      return b2;
    }
  }
  
  /**
  * Un metodo que hara dos cosas dedicir que burbuja tienen la h mas pequeña
  * y regresar tal burbuja, al mismo tiempo que modifica el otro valor indice de la burbuja
  * para adecuarlo ala modificacion del algotimo de miniMax
  * @param Burubuja b1 -- una burbuja
  * @param Burbuja b2 -- otra burbuja a comparar
  * @param int i -- el nuevo indice a modificar en la burbuja ganadora
  * @return Burbuja, la que tiene la h mas pequeña con el nuevo indice
  */
  static Burbuja minimaB(Burbuja b1, Burbuja b2, int i){
    if(b1.getH() <= b2.getH()){
      b1.setI(i);
      return b1;
    }else{
      b2.setI(i);
      return b2;
    }
  }
  
}
