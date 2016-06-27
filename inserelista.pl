insereInicio(H, L, [H|L]):- !.
insereFim(T, [H], L):- insereInicio(H,[T],L), !.
insereFim(N, [H|T], L):- insereFim(N,T,X), insereInicio(H, X, L).

iniciar2 :- insereFim(5, [1,2,3,4], L2),
write(L2).