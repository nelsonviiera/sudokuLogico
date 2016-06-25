%abre a base de conhecimento
abrirBase :- consult(base_Sudoku).

printf([X|Y], I, F) :- write(X), nl, A is I+1, A < F, printf(Y, A, F).

iniciar :- abrirBase,nl,
     write('            Jogo Sudoku em Prolog'),nl,
     write('Desenvolvido por Nelson Vieira e Tiago Umemura'),nl,
     write('----------------------------------------------'),nl,
     write('Tabuleiro inicial:'), nl,
     atribui(L),
     printf(L,0,9),
     fail.