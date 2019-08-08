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
esPrimeraMarca(laSerenisima).
esPrimeraMarca(gallo).
esPrimeraMarca(vienisima).

descuento(Producto,Descuento):-
  precioUnitario(Producto,_),
  descuentoPorProducto(Producto,Descuento).
descuentoPorProducto(arroz(luchetti),15).
descuentoPorProducto(salchichas(Marca,Cantidad),5) :- Marca \= vienisima, Cantidad > 6.
descuentoPorProducto(lacteo(_,leche),20).
descuentoPorProducto(lacteo(Marca,queso(_)),20) :- esPrimeraMarca(Marca).


% PUNTO 4
esCliente(Alguien):-
  compro(Alguien,_).

expertoEnAhorro(Cliente):-
  esCliente(Cliente),
  forall(esBuenProductodeAhorro(Producto), compro(Cliente,Producto)).

esBuenProductodeAhorro(Producto):-
  precioUnitario(Producto,_),
  tieneDescuento(Producto),
  productoDePrimera(Producto).

tieneDescuento(Producto):- descuento(Producto,_). %se debate

productoDePrimera(Producto):- 
  esDeMarca(Producto,Marca),
  esPrimeraMarca(Marca).

% PUNTO 5
totalAPagar(Cliente,TotalCompra):-
  esCliente(Cliente),
  findall(Precio,precioAPagar(Cliente,Precio),Precios),
  sumlist(Precios,TotalCompra).


precioAPagar(Cliente,Precio):-
  compro(Cliente,Producto),
  precioUnitario(Producto,PrecioUnitario),
  precioReal(Producto,PrecioUnitario,Precio).

precioReal(Producto,Precio,PrecioFinal):-
  descuento(Producto,Descuento),
  PrecioFinal is Precio - Precio * (Descuento/100).


precioReal(Producto,PrecioFinal,PrecioFinal):-  not(descuento(Producto,_)).

% PUNTO 6

%duenio(MarcaDuenia,OtraMarca).
duenio(laSerenisima, gandara).
duenio(gandara, vacalin).

provee(Marca,ListaDeProductos):-
  esMarca(Marca),
  findall(Producto,proveeProducto(Producto,Marca),ListaDeProductos).

proveeProducto(Producto,Marca):-  
  precioUnitario(Producto,_),
  esDeMarca(Producto,Marca).

proveeProducto(Producto,Marca):- 
  duenio(Marca,OtraMarca),
  proveeProducto(Producto,OtraMarca).
