% precioUnitario(Producto,Precio)
% donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)

precioUnitario(arroz(gallo),65).
precioUnitario(lacteo(laSerenisima,leche), 46).
precioUnitario(lacteo(tresNinias,leche), 34).
precioUnitario(lacteo(laSerenisima,crema), 34).
precioUnitario(lacteo(gandara,queso(gouda)), 213).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 212).
precioUnitario(salchichas(vienisima,12), 129).
precioUnitario(salchichas(vienisima, 6), 85).
precioUnitario(salchichas(granjaDelSol, 8), 95).

% PUNTO 1
% comrpo/2: persona y producto (functor)
compro(juan,lacteo(laSerenisima, leche)).
compro(juan,lacteo(laSerenisima, crema)).
compro(juan,arroz(gallo)).
compro(flora,salchichas(vienisima,12)).
compro(flora,salchichas(vienisima,12)).
compro(flora,salchichas(granjaDelSol,8)).
% no escribo nada con nahue sólo escribo lo verdadero (universo cerrado) 


% PUNTO 2
clienteFiel(Cliente,MarcaFiel):-
  compro(Cliente,_),
  esMarca(MarcaFiel),
  %forall(otro producto, no encontró de su marca)
  forall(
     productoDeOtraMarca(Cliente,MarcaFiel,Producto),
     not(hayDeMiMarca(MarcaFiel,Producto))).

productoDeOtraMarca(Cliente,MarcaFiel,Producto):-
  compro(Cliente,Producto),
  not(esDeMarca(Producto,MarcaFiel)).

hayDeMiMarca(MarcaFiel,ProductoSospechoso):-
  mismoProducto(Producto,ProductoSospechoso),
  esDeMarca(Producto,MarcaFiel),
  precioUnitario(Producto,_).

esDeMarca(arroz(Marca),Marca).
esDeMarca(lacteo(Marca,_),Marca).
esDeMarca(salchichas(Marca,_),Marca).

mismoProducto(arroz(_),arroz(_)).
mismoProducto(lacteo(_,Tipo),lacteo(_,Tipo)).
mismoProducto(salchichas(_,_),salchichas(_,_)).

esMarca(Marca):-
  precioUnitario(Producto,_),
  esDeMarca(Producto,Marca).

% PUNTO 3