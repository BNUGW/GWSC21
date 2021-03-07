function randabVec = customrand(a,b,N)
initRandVec = rand(1,N);
randabVec = initRandVec.*(b-a)+a ;
