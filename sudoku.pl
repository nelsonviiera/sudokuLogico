%abre a base de conhecimento
abrirBase :- consult(base_Sudoku).

%inserir elemento em uma lista
insereInicio(H, L, [H|L]):- !.
insereFim(T, [H], L):- insereInicio(H,[T],L), !.
insereFim(N, [H|T], L):- insereFim(N,T,X), insereInicio(H, X, L).

%printa tabuleiro.
printf([X|Y], I, F) :- write(X), nl, A is I+1, A < F, printf(Y, A, F);
					A is I+1, A >= F.

%linha e coluna alvo
getNum(L, Li, Co, N) :- getLinha(L, Li, 0, [Linha]), getColuna(Linha, Co, 0, Nx), N is Nx.

getLinha([X1|X2], Li, La, [Linha]) :- La == Li, Linha = X1; 
                                      La < Li, Laux is La+1, getLinha(X2, Li, Laux, [Linha]).

getColuna([X3|X4], Co, Ca, Nx) :- Ca == Co, Nx = X3;
                                  Ca < Co, Caux is Ca+1, getColuna(X4, Co, Caux, Nx).

%linha e coluna alvo para mudar o valor
                        %0  %0
setNum([X1|X2], Li, Co, La, Ca, NovoValor, [[Result]]) :- La < 9, La \== 0, La == Li, Laux is La+1, setColuna(X1, Co, Ca, NovoValor, [LinhaMod]), insereFim(LinhaMod, Result, Resultaux), setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
                                                          La < 9, La \== 0, La \== Li, Laux is La+1, insereFim(X1, Result, Resultaux), setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
                                                          La == 0, Resultaux = [[X1]], Laux is La+1,setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
                                                          printf(Result, 0, 9).

                       %0
setColuna([X1|X2], Co, Ca, NovoValor,[LinhaMod]) :- Ca < 9, Ca \== 0, Ca == Co, Caux is Ca+1, insereFim(NovoValor, LinhaMod, LinhaModaux), setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
                                                    Ca < 9, Ca \== 0, Ca \== Co, Caux is Ca+1, insereFim(X1, LinhaMod, LinhaModaux), setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
                                                    Ca == 0, Caux is Ca+1, LinhaModaux = [X1], setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
                                                    printf(LinhaMod, 0, 9).

iniciar :- abrirBase,nl,
     write('            Jogo Sudoku em Prolog'),nl,
     write('Desenvolvido por Nelson Vieira e Tiago Umemura'),nl,
     write('----------------------------------------------'),nl,
     write('Tabuleiro inicial:'), nl,
     atribui(L),
     printf(L, 0, 9),%printar matriz
     nl,
     getNum(L, 8, 1, N),
     nl,
     write(N),
     nl,
     setNum(L, 1, 1, 0, 0, 6, Result),
     nl,
     printf(Result,0,9),
     nl,
     write('Fim'),
     nl,
     printf(L,0,9),
     fail.