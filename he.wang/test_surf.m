
addpath SDMBIGDAT19/CODES/

clear; clc; close all;
ffparams = struct('rmin',-5,...
                     'rmax',5 ...
                  );
[X,Y] = meshgrid(linspace(0, 1, 200),...
                   linspace(0, 1, 200));
Z = reshape(crcbpsotestfunc([X(:)'; Y(:)']', ffparams), 200, 200);
figure(1)
surf(X, Y, Z, 'LineStyle', 'none');
axis xy;
xlabel('x_1');
ylabel('x_2');
zlabel('f(x_1, x_2)')
saveas(gcf,'test_surf','png')