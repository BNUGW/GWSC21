N = 10000 ; 
uVec = customrand(-2,1,N);
figure(1);
histogram(uVec,'normalization','pdf')



nVec = customrandn(1.5,2,N);
figure(2);
histogram(nVec,'normalization','pdf')
