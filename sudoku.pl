%Carrega biblioteca random
use_module(library(random)).

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
%setNum([X1|X2], Li, Co, La, Ca, NovoValor, Result) :- La < 9, La > 0, La == Li, Laux is La+1, setColuna(X1, Co, Ca, NovoValor, LinhaMod), insereFim(LinhaMod, Result, Resultaux), setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
%                                                      La < 9, La > 0, Li \== La, Laux is La+1, insereFim(X1, Result, Resultaux), setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
%                                                     La == 0, Resultaux = [X1], Laux is La+1, setNum(X2, Li, Co, Laux, Ca, NovoValor, Resultaux);
%                                                      La == 8, insereFim(X1, Result, Resultaux),printf(Resultaux, 0, 9).
%
                       %0
%setColuna([X1|X2], Co, Ca, NovoValor,LinhaMod) :- Ca < 9, Ca > 0, Ca == Co, Caux is Ca+1, insereFim(NovoValor, LinhaMod, LinhaModaux), setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
%                                                  Ca < 9, Ca > 0, Ca \== Co, Caux is Ca+1, insereFim(X1, LinhaMod, LinhaModaux), setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
%                                                  Ca == 0, Caux is Ca+1, LinhaModaux = [X1],setColuna(X2, Co, Caux, NovoValor, LinhaModaux);
%                                                  Ca == 8, insereFim(X1, LinhaMod, LinhaModaux), write(LinhaModaux).

setNum(L, Li, Co, N, Laux) :- trocaLinha(Li, Co, N, L, Laux).
                      
trocaLinha(0, Co, N, [H|T], [Laux|T]) :- trocaColuna(Co, N, H, Laux).
trocaLinha(Li, Co, N, [H|T], [H|Laux]) :- Liaux is Li - 1, trocaLinha(Liaux, Co, N, T, Laux).
                      
trocaColuna(0, N, [_|T], [N|T]).                      
trocaColuna(Co, N, [H|T], [H|Laux]) :- Coaux is Co - 1, trocaColuna(Coaux, N, T, Laux).

% 1 = True. 0 = False.
verificaLinha(L, Li, Co, N, Loop, Verifica) :- Loop < 9, getNum(L, Li, Loop, Naux), N == Naux, Verifica is 1;
                                               Loop < 9, getNum(L, Li, Loop, Naux), N \== Naux, Loopaux is Loop+1, verificaLinha(L, Li, Loopaux, N, Loopaux, Verifica);
                                               Loop == 9, Verifica is 0.

verificaColuna(L, Li, Co, N, Loop, Verifica) :- Loop < 9, getNum(L, Loop, Co, Naux), N == Naux, Verifica is 1;
                                                Loop < 9, getNum(L, Loop, Co, Naux), N \== Naux, Loopaux is Loop+1, verificaColuna(L, Loopaux, Co, N, Loopaux, Verifica);
                                                Loop == 9, Verifica is 0.


verificaQuadrante(L, InicioL, FimL, InicioC, FimC, AuxC, N, Verifica) :- InicioL < FimL, InicioC < FimC, getNum(L, InicioL, InicioC, Naux), N == Naux, Verifica = 1;
                                                                         InicioL < FimL, InicioC < FimC, getNum(L, InicioL, InicioC, Naux), N \== Naux, InicioCaux is InicioC+1, verificaQuadrante(L, InicioL, FimL, InicioCaux, FimC, AuxC, N, Verifica);
                                                                         InicioL < FimL, InicioC == FimC, InicioLaux is InicioL+1, verificaQuadrante(L, InicioLaux, FimL, AuxC, FimC, AuxC, N, Verifica);
                                                                         InicioL == FimL, Verifica is 0.

%verifica sudoku linha coluna n
%     | ((getNum sudoku linha coluna) == n) = True
%     | ((getNum sudoku linha coluna ) /= 0) = False
%     | (verificaLinha sudoku linha coluna n 0) = False--ultimo parametro loop que inicia no 0 e vai até 8
%     | (verificaColuna sudoku linha coluna n 0) = False
%     | (verificaQuadrante sudoku ((div linha 3)*3) (((div linha 3)+1)*3) ((div coluna 3)*3) (((div coluna 3)+1)*3) ((div coluna 3)*3) n ) = False
%     | otherwise = True
verifica(L, Li, Co, N, Verifica) :- getNum(L, Li, Co, Naux), N == Naux, Verifica is 1;
                                    getNum(L, Li, Co, Naux), Naux \== 0, Verifica is 0;
                                    verificaLinha(L, Li, Co, N, 0, VerificaL), VerificaL == 0, Verifica is 0;
                                    verificaColuna(L, Li, Co, N, 0, VerificaC), VerificaC == 0, Verifica is 0;
                                    verificaQuadrante(L, (Li mod 3)*3, ((Li mod 3)+1)*3, (Co mod 3)*3, ((Co mod 3)+1)*3, (Co mod 3)*3, N, VerificaQ), VerificaQ == 0, Verifica is 0;
                                    Verifica is 1.


%gerarSudoku matriz n x i j k = do
%  if (i < n) then do
%    if (j < n) then do
%      if (k < n*n) then do
%        gerarSudoku (setNum matriz (n*i+j) k 0 0 ((mod x (n*n)) + 1)) n (x+1) i j (k+1)
%      else do
%        gerarSudoku matriz n (x+n) i (j+1) 0  
%    else do

%      gerarSudoku matriz n (x+1) (i+1) 0 0

%  else do
%    matriz
%setNum(L, Li, Co, N, Laux)
gerarSudoku(L, N, X, I, J, K, Laux) :- 
I < N, J < N, K < N*N, Li is N*I+J, Num is (X mod (N*N))+1, setNum(L, Li, K, Num, Tabuleiroaux), Kaux is K+1, Xaux is X+1, gerarSudoku(Tabuleiroaux, N, Xaux, I, J, Kaux, Laux);
I < N, J < N, K >= N*N, Xaux is X+N, Jaux is J+1, gerarSudoku(L, N, Xaux, I, Jaux, 0, Laux);
I < N, J >= N, Xaux is X+1, Iaux is I+1, gerarSudoku(L, N, Xaux, Iaux, 0, 0, Laux);
I == N, Laux = L.

iniciar :- abrirBase,nl,

     write('            Jogo Sudoku em Prolog'),nl,
     write('Desenvolvido por Nelson Vieira e Tiago Umemura'),nl,
     write('----------------------------------------------'),nl,
     write('Tabuleiro inicial:'), nl,
     atribui(L),
     printf(L, 0, 9),%printar matriz
     nl,
     random(0, 9, Out),
     write('Aloha '),
     write(Out),
     nl,
     gerarSudoku(L, 3, Out, 0, 0, 0, Laux),
     write(Laux),
     nl,
     write('Fim'),
     nl,
     fail.