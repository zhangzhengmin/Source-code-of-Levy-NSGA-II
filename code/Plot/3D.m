A=xlsread('sp1.xls');
x = A(:,1);y = A(:,2); z =A(:,3);
xlin = linspace(min(x),max(x),33);
ylin = linspace(min(y),max(y),33);
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(x,y,z,X,Y,'v4');
mesh(X,Y,Z) %interpolated
axis tight; hold on
plot3(x,y,z,'r.','MarkerSize',10) %nonuniform

