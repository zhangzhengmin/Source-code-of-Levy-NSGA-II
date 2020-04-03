A=xlsread('sp1.xls');
x=A(:,1);
y=A(:,2);
plot(x,y,'r.','MarkerSize',15);
axis([3.7,4.2,1.4,3]);