% guardas linguagem funcional == utilizar ou em prolog ";" e operadoresde comparação "X == Y"


animal(dog).

read_animal(X) :-
  write('please type animal name:'),
  nl,
  read(X),
  animal(X).
