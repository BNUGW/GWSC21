M=10000;
xVec = rand(1,M);
figure(1);
histogram(xVec,'normalization','pdf')


M=1000000;
xVec = rand(1,M);
figure(2);
histogram(xVec,'normalization','pdf')


figure(3);
M=10000
yVec = randn(1,M);
histogram(yVec,'normalization','pdf')