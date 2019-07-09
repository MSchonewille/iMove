
function [folded]=ifolding1(timefile,eyefile,sf,freq,ncycl,startonset)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%													                %%
%%							Folding, binning and averaging          %%
%%                          of data traces      	            	%%
%%																	%%
%%							Marcel de Jeu       					%%
%%																	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc;
binsize=1/sf;
totnbin=round(sf/freq);
fold=[];folded=[]; 
for i=1:totnbin 
    n=0;
    for j=1:ncycl
        timebin=startonset(j)+i; 
        timem=timebin/sf;
        m=find((timem+0.004) > timefile & timefile > (timem-0.004));
        if m
           fold=[fold;eyefile(m(1))];
           n=n+1;
        else n=n+0;
        end;
    end;
    ave=mean(fold);
    cv=std(fold)/abs(ave);
    folded=[folded;i,n,ave,cv];
    fold=0;
end;

