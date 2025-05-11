function p =  mypolyfit(xx,yy,OrderNo,x0,y0)

%%% This is the polyfit function that constrant the cuve fitting passing a
%%% certain point (x0,y0)


% hd200=figure(200);plot(xx,yy,'.b-')

% hold on
c = polyfit(xx,yy,OrderNo);  
yhat = polyval( c, xx );
% plot(xx,yhat,'r','linewidth',2)


xx = xx(:); %reshape the data into a column vector
yy = yy(:);
% 'C' is the Vandermonde matrix for 'x'
n = OrderNo; % Degree of polynomial to fit
V(:,n+1) = ones(length(xx),1,class(xx));
for j = n:-1:1
     V(:,j) = xx.*V(:,j+1);
end
C = V;


% 'd' is the vector of target values, 'y'.
d = yy;
%
% There are no inequality constraints in this case, i.e., 
A = [];
b = [];



%%
% We use linear equality constraints to force the curve to hit the required point. In
% this case, 'Aeq' is the Vandermoonde matrix for 'x0'
Aeq = [x0(1).^(n:-1:0);x0(2).^(n:-1:0)];
% and 'beq' is the value the curve should take at that point
beq = y0;
%% 
p = lsqlin( C, d, A, b, Aeq, beq )
%%
% We can then use POLYVAL to evaluate the fitted curve
yhat = polyval( p, xx );
%%
% Plot original data
% plot(xx,yy,'.b-') 
% hold on
% Plot point to go through
% plot(x0,y0,'gx','linewidth',4) 
% Plot fitted data
% plot(xx,yhat,'r','linewidth',2) 
% hold off
% pause;
% close(hd200);