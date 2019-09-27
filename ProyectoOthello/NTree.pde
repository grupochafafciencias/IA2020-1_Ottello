class  NTree<E>{
    E dato;
    ArrayList<NTree> ListHijos;
    
    NTree(E dato){
      this.dato = dato;
      ListHijos = new ArrayList<>();
    }
    
    E getDato(){
      return dato;
    }
    
    ArrayList<NTree> getHijos(){
      return ListHijos;
    }
    
    boolean isHoja(){
      return ListHijos.isEmpty();
    }
    
    //recuerda siempre primero crear el nodo y despues ya se puede usar
    void addHijo(NTree n){
      ListHijos.add(n);
    }
}
