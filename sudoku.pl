%abre a base de conhecimento
abrirBase :- consult(base_Sudoku).

%printa tabuleiro.
printf([X|Y], I, F) :- write(X), nl, A is I+1, A < F, printf(Y, A, F);
					A is I+1, A >= F, write('matriz printada').

concatenate(List1, List2, Result) :- append(List1, List2, Result).

%linha e coluna alvo
getNum(L, Li, Co, N) :- getLinha(L, Li, 0, [Linha]), getColuna(Linha, Co, 0, Nx), N is Nx.

getLinha([X1|X2], Li, La, [Linha]) :- La == Li, Linha = X1; 
                                      La < Li, Laux is La+1, getLinha(X2, Li, Laux, [Linha]).

getColuna([X3|X4], Co, Ca, Nx) :- Ca == Co, Nx = X3;
                                  Ca < Co, Caux is Ca+1, getColuna(X4, Co, Caux, Nx).

%linha e coluna alvo para mudar o valor
                        %0  %0
setNum([X1|X2], Li, Co, La, Ca, NovoValor, [[Result]]) :- La == Li, setColuna(X1, Co, Ca, NovoValor, [LinhaMod]), concatenate(Result, [[LinhaMod]], Result2), concatenate(Result2, X2, Result3), Result = Result3;
                                                          La < Li, Laux is La+1, concatenate(Result, X1, Result2), setNum(X2, Li, Co, Laux, Ca, NovoValor, Result2).


setColuna([X1|X2], Co, Ca, NovoValor,[LinhaMod]) :- Ca == Co, concatenate(NovoValor, [LinhaMod], Result), concatenate(Result, X2, Result2), LinhaMod = Result2;
                                                    Ca < Co, Caux is Ca+1, concatenate(LinhaMod, X1, Result), setColuna(X2, Co, Caux, NovoValor, Result).  

iniciar :- abrirBase,nl,
     write('            Jogo Sudoku em Prolog'),nl,
     write('Desenvolvido por Nelson Vieira e Tiago Umemura'),nl,
     write('----------------------------------------------'),nl,
     write('Tabuleiro inicial:'), nl,
     atribui(L),
     printf(L, 0, 9),%printar matriz
     nl,
     getNum(L, 8, 8, N),
     nl,
     write(N),
     nl,
     setNum(L, 0, 0, 0, 0, 6, Result),
     nl,
     write(Result),
     nl,
     write('Fim'),
     nl,
     printf(L,0,9),
     fail.