%% Test harness for CRCBPSO 
% The fitness function called is CRCBPSOTESTFUNC. 
addpath ../../SDMBIGDAT19/CODES
ffparams = struct('rmin',-5,...
                     'rmax',5 ...
                  );
% Fitness function handle.
fitFuncHandle = @(x) crcbpsotestfunc(x,ffparams);
%%
% Call PSO.
rng('default')
psoOut = crcbpso(fitFuncHandle,2);

%% Estimated parameters
% Best standardized and real coordinates found.
stdCoord = psoOut.bestLocation;
[~,realCoord] = fitFuncHandle(stdCoord);
disp(realCoord);
%% surf plot
x1 = -5:0.1:5; 
[X1,X2] = meshgrid(x1,x1);
Z = zeros(size(X1));
for i = 1:length(x1)
    for j = 1:length(x1)
        Z(i,j) = fitFuncHandle([(x1(j)+5)/10,(x1(i)+5)/10]);
    end
end
surf(X1,X2,Z,'EdgeColor','none')
xlabel('x_1')
ylabel('x_2')
zlabel('f(x_1,x_2)')