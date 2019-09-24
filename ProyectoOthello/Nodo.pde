class Nodo<E>{
    E dato;
    ArrayList<Nodo> ListHijos;
    
    Nodo(E dato){
      this.dato = dato;
      ListHijos = new ArrayList<>();
    }
    
    E getDato(){
      return dato;
    }
    
    ArrayList<Nodo> getHijos(){
      return ListHijos;
    }
    
    boolean isHoja(){
      return ListHijos.isEmpty();
    }
    
    //recuerda siempre primero crear el nodo y despues ya se puede usar
    void addHijo(Nodo n){
      ListHijos.add(n);
    }
}
