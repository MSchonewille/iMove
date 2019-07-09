%program for sine wave analysis of eye-video data captured by the ISCAN-2
%by Marcel de Jeu

global rsphndl stmhndl rmvHndl strresult textRHndl sf parfit rpcor

('D:\')

tabstr=[];
strresult=[];

%loading calibration and data files (+calibration procedure)
[calname,dirname]=uigetfile({'*.smr'},'Select Calibration File');
cd(dirname);
igetcalibr(calname);
uiwait;
[videoname,dirname]=uigetfiles('*.smr','Select Data Files');
cd(dirname);
videoname1=videoname';
nrow=size(videoname1);
vorfig;
set(gcf,'doublebuffer','on');

for tl=1:nrow(1)
    [eye,table]=igetvideo(char(videoname1(tl,1)));

    %corneal reflection and calibration correction
    rpvideo=parfit(1).*eye.dia+parfit(2);
    eye.cal=asin((eye.hor)./rpvideo)*180/pi;
    eye.cal=eye.cal; 
   
    if std(table.drum)>std(table.table)
        tablesignal=table.drum;
        tm=3;
        freq.table=0;
        ampl.table=0;
        freq.drum=[];
        ampl.drum=[];
        amp.est=table.tableamp;
    else tablesignal=table.table;
        tm=1;
        freq.drum=0;
        ampl.drum=0;
        freq.table=[];
        ampl.table=[];
        amp.est=table.drumamp;
    end;
        
    freq.est=table.freq;
    
    %plots
    axes(rsphndl),plot(table.time,tablesignal,'b');
    ylim([-20 20]);
    hold on
    axes(rsphndl),plot(table.time,eye.cal,'r');
    xlabel('time (s)');
    ylabel('pupil pos. (degr.)');
    title('Eye movement during visual and/or vestibular stimuli','FontWeight','bold');
    hold off
    
    vel.eye=drpdiff(eye.cal,table.sf);
    vel.table=drpdiff(tablesignal,table.sf);
    
    signal.eye=filterit(vel.eye,table.sf,30); 
    signal.table=filterit(vel.table,table.sf,30);
    
    cr=filterit(signal.eye,table.sf,10);
    crit=takeoutsac1(cr,table.sf);
    if mean(crit)~=1
           nn=find(crit);
           signal.eye=signal.eye(nn);
           table.time2=table.time(nn);
      else table.time2=table.time; %
    end;
                 
    %find cycles
    onsetnegtrig=0:table.sf/freq.est:length(signal.table);
    
    %binning, folding and averaging
    aantcyc=(length(onsetnegtrig)-1);
    [ave.eye]=ifolding1(table.time2,signal.eye',table.sf,freq.est,aantcyc,onsetnegtrig);
    [ave.table]=ifolding1(table.time,signal.table',table.sf,freq.est,aantcyc,onsetnegtrig);

    [ftbl,ampltbl,gain,phase,amp,dc,ave]=isiitvid(ave,freq.est,amp.est,table.sf,tm);
    ampltbla=ampltbl/(ftbl*2*pi);
    
    if isempty(freq.table)
        freq.table=ftbl; ampl.table=ampltbla;
    else freq.drum=ftbl; ampl.drum=ampltbla;
    end;
    
    S=corrcoef(ave.eye(:,3),ave.fit.eye);
    
    tabstr(tl,1)=freq.table;
    tabstr(tl,2)=ampl.table;
    tabstr(tl,3)=freq.drum;
    tabstr(tl,4)=ampl.drum;
    tabstr(tl,5)=table.light;
    tabstr(tl,6)=gain;
    tabstr(tl,7)=phase;
    tabstr(tl,8)=dc;
    tabstr(tl,9)=mean(ave.eye(:,2));
    tabstr(tl,10)=S(1,2);
    tabstr(tl,11)=mean(ave.eye(:,4));
    
    lp=length(videoname1{tl,1});
    lm=find(videoname1{tl,1} == '_');
    min=str2num(char(videoname1{tl,1}(1,lm+1:lp-4)));
    tabstr(tl,12)=min;
    
    if tm==1 
        strresult=[tabstr(tl,1),tabstr(tl,2),tabstr(tl,6),tabstr(tl,7);strresult];
    else strresult=[tabstr(tl,3),tabstr(tl,4),tabstr(tl,6),tabstr(tl,7);strresult];
    end;
    
    strresult2=num2str(strresult,'%10.2f');
    textRHndl=findobj(gcf,'Tag','Editresult');
    set(textRHndl,'String',strresult2);

    axes(stmhndl),plot(ave.eye(:,1)/table.sf,ave.fit.eye,'k-');
    hold on
    axes(stmhndl),plot(ave.table(:,1)/table.sf,ave.fit.table,'k-');
    axes(stmhndl),plot(ave.eye(:,1)/table.sf,ave.eye(:,3),'r-');
    axes(stmhndl),plot(ave.table(:,1)/table.sf,ave.table(:,3),'b-');
    xlabel('time (bins)');
    ylabel('pupil vel. (degr./s)');
    title('Averaged eye movement','FontWeight','bold');
    hold off
    clear freq.table ampl.table freq.drum ampl.drum aver2 aver1 n;
end

tabstr=sortrows(tabstr,12);%11
fname=char(videoname1(1,1));
fname=fname(1:length(fname)-4);
save(fname,'tabstr');
fnamexls=[fname '.xls'];
header='my data'; colname={'freq table','ampl table','freq drum','ampl drum','light','gain','phase','dc','cycles used','gof','CV'};
xlswrite(tabstr,header,colname,fnamexls);
tabstr
keep('videoname1','parfit','rsphndl','stmhndl','onsetnegtrig','ave','table');

%clear all