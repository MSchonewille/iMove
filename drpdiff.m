% 3 point differentiator

function cc=drpdiff(cc,sf)

cof=[-1 0 1];               
cof=cof.*(sf/2);             
temp=cc'*cof;                
temp=temp';
aantal=length(temp);

temp2=[temp(1,1:aantal-2);temp(2,2:aantal-1);temp(3,3:aantal)];   
e=sum(temp2);                
cc=[e(1) e e(aantal-2)];     
