function [ftbl,ampltbl,g,p,a,dc,ave]=isiitvid(ave,freq,amp,sf,tm)


ofreq=freq;
qq(1,:)=ave.table(:,1)'/sf;
qq(2,:)=ave.table(:,3)';

iniPars(1)=amp;
iniPars(2)=freq;
iniPars(3)=0; 
iniPars(4)=0; 
optimset;
pars = fminsearch('sit',iniPars,[],qq);
ftbl=pars(2);
ampltbl=pars(1);
clear qq;
clear iniPars;

%-----------------------------------------------------------------

qq(1,:)=ave.eye(:,1)'/sf; 
qq(2,:)=ave.eye(:,3)';

iniPars(1)=max(ave.eye(:,3));
if tm==1 iniPars(2)=pi; else iniPars(2)=0; end; 
iniPars(3)=0; 
optimset;
part = fminsearch('si',iniPars,[],qq,pars(2));

ave.fit.eye=part(1)*cos(2*pi*pars(2)*qq(1,:)+part(2))+part(3);
ave.fit.table=pars(1)*cos(2*pi*pars(2)*qq(1,:)+pars(3))+pars(4);


% add pi for negative amplitude
pars(3)=pars(3)+pi*floor(.5*sign(pars(1)));
part(2)=part(2)+pi*floor(.5*sign(part(1)));
% place value between -2pi and +2pi
pars(3)=pars(3)-round((pars(3)/(2*pi))-.5*sign(pars(3)))*2*pi;
part(2)=part(2)-round((part(2)/(2*pi))-.5*sign(pars(3)))*2*pi;

part(2)=(part(2)*180/pi); 
pars(3)=(pars(3)*180/pi);

g=abs(real(part(1))/real(pars(1)));
p=real(part(2))-real(pars(3));
if ((tm==1) & (part(1) > 0) & (pars(1) > 0)) p=p+180; end;
if ((tm==1) & (part(1) < 0) & (pars(1) < 0)) p=p+180; end;
if ((tm==3) & (part(1) > 0) & (pars(1) < 0)) p=p-180; end;
if ((tm==3) & (part(1) < 0) & (pars(1) > 0)) p=p-180; end;
a=real(pars(1));
dc=real(part(3));
