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


verifica(L, Li, Co, N, Verifica) :- getNum(L, Li, Co, Naux), N == Naux, Verifica is 1;
                                    getNum(L, Li, Co, Naux), Naux \== 0, Verifica is 0;
                                    verificaLinha(L, Li, Co, N, 0, VerificaL), VerificaL == 0, Verifica is 0;
                                    verificaColuna(L, Li, Co, N, 0, VerificaC), VerificaC == 0, Verifica is 0;
                                    verificaQuadrante(L, (Li mod 3)*3, ((Li mod 3)+1)*3, (Co mod 3)*3, ((Co mod 3)+1)*3, (Co mod 3)*3, N, VerificaQ), VerificaQ == 0, Verifica is 0;
                                    Verifica is 1.


gerarSudoku(L, N, X, I, J, K, Laux) :- I < N, J < N, K < N*N, Li is N*I+J, Num is (X mod (N*N))+1, setNum(L, Li, K, Num, Tabuleiroaux), Kaux is K+1, Xaux is X+1, gerarSudoku(Tabuleiroaux, N, Xaux, I, J, Kaux, Laux);
                                       I < N, J < N, K >= N*N, Xaux is X+N, Jaux is J+1, gerarSudoku(L, N, Xaux, I, Jaux, 0, Laux);
                                       I < N, J >= N, Xaux is X+1, Iaux is I+1, gerarSudoku(L, N, Xaux, Iaux, 0, 0, Laux);
                                       I == N, Laux = L.

%gerarJogo matriz nEspaco cont = do
%     if (cont /= nEspaco) then do
%          linR <- randomRIO (0, 8 :: Int)
%          colR <- randomRIO (0, 8 :: Int)
%          if ((getNum matriz linR colR) == 0) then do
%               gerarJogo matriz nEspaco cont
%          else do
%               gerarJogo (setNum matriz linR colR 0 0 0) nEspaco (cont+1)
%     else do
%          matriz
%getNum(L, Li, Co, N)
%setNum(L, Li, Co, N, Laux)
tiraNumeros(L, NEspaco, NovoSudoku) :- 
NEspaco > 0, random(0, 9, Li), random(0, 9, Co), getNum(L, Li, Co, N), N == 0, tiraNumeros(L, NEspaco, NovoSudoku);
NEspaco > 0, random(0, 9, Li), random(0, 9, Co), getNum(L, Li, Co, N), N \== 0, setNum(L, Li, Co, 0, Laux), NEspacoaux is NEspaco-1, tiraNumeros(Laux, NEspacoaux, NovoSudoku);
NEspaco == 0, NovoSudoku = L.

jogar(SudokuZeros, Sudoku, QtdZeros) :- 
QtdZeros > 0, write('Informe a linha e coluna '), read(Li), read(Co), read(Valor), 
getNum(Sudoku, Li, Co, N), N == Valor, setNum(SudokuZeros, Li, Co, Valor, SudokuAux), 
QtdZerosAux is QtdZeros-1, printf(SudokuAux, 0, 9), jogar(SudokuAux, Sudoku, QtdZerosAux);

QtdZeros > 0, write('Informe a linha e coluna '), read(Li), read(Co), read(Valor), 
getNum(Sudoku, Li, Co, N), N \== Valor, write('Errou, tente novamente'), nl, jogar(SudokuZeros, Sudoku, QtdZeros);

QtdZeros == 0, write('Parabéns, você completou o Sudoku!'), halt(0).

iniciar :- abrirBase,nl,
     write('            Jogo Sudoku em Prolog'),nl,
     write('Desenvolvido por Nelson Vieira e Tiago Umemura'),nl,
     write('----------------------------------------------'),nl,
     atribui(L),
     %Semente para não gerar sudoku igual
     random(0, 9, Rand),
     write('Tabuleiro inicial:'), nl,
     gerarSudoku(L, 3, Rand, 0, 0, 0, Sudoku),
     printf(Sudoku, 0, 9), nl,
     %1 = 10 espaços vazios. 2 = 20. 3 = 30
     write('Escolha a dificuldade (1 - 2 - 3) Não se esqueça do ponto'), nl,
     read(Dif),
     Difaux is Dif * 10,
     tiraNumeros(Sudoku, Difaux, NovoSudoku),
     printf(NovoSudoku, 0, 9), nl,
     jogar(NovoSudoku, Sudoku, Difaux),nl,
     write('Fim'),
     nl,
     fail.