function randnVec = customrandn(a, b, N)
initRandnVec = randn(1,N);
randnVec = initRandnVec*b+a ;