function qq=takeoutsac1(cc,sf)

global AHANDLE
presactime=0.02; %seconds
postsactime=0.08; %seconds
presacbin=round(presactime*sf(1));
postsacbin=round(postsactime*sf(1));
aa=abs(cc);
[bb,i]=sort(aa);

%find cut off
le=length(bb);
med=round(le/2);
cut=75; 
r=find(bb>cut);
qw=isempty(r);

if qw==1
   bb(1:le)=1;
   accbin(i)=bb;
else
   v=axis;
   l(2)=line([aa(r(1)) aa(r(1))],[v(3) v(4)]);
   l(3)=line([v(1) v(2)],[cut cut]);
   set (l(2),'color',[1 0 0])
   set (l(3),'color',[1 0 0])
   drawnow
   bb(1:r)=1;
   bb((r+1):end)=0;
   accbin(i)=bb;
   
   ll=find(accbin<1);
   for x=1:length(ll)
      if ll(x)>251
         accbin(ll(x)-presacbin:ll(x)+postsacbin)=0;
         else
         accbin(1:ll(x)+postsacbin)=0;
      end
   end
end

qq=accbin(1:length(i));
disp('takeoutsac1');
