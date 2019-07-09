function igetcalibr(fname)

global rsphndl stmhndl rmvHndl Ytxt1 Ytxt2 Xtxt1 Xtxt2 xrange calibsignal rpcor


calibsignal= smrreadADC(fname,'all');

col=[calibsignal.ch3.nofsamples;calibsignal.ch4.nofsamples];

maxt=min(col)/calibsignal.ch3.fsamp;
nrsamp=calibsignal.ch3.nofsamples;
aa=linspace(0,maxt,nrsamp);
calibsignal.time.eye=aa;
xrange=max(calibsignal.time.eye);
ydat=calibsignal.time.eye'; 
ydat(:,1)=20; yrange=ydat(:,1);

calibsignal.eyecalhor=0.00015*calibsignal.ch4.ADC(1:4:min(col))*calibsignal.ch4.scale+calibsignal.ch4.offset;
calibsignal.eyecaldia=0.00015*calibsignal.ch3.ADC(1:4:min(col))*calibsignal.ch3.scale+calibsignal.ch3.offset;
calibsignal.time.eye=calibsignal.time.eye(1:4:min(col));    

iscan2fig3;
set(gcf,'doublebuffer','on');
scrollplot2(30,calibsignal.time.eye,calibsignal.eyecalhor,calibsignal.time.eye,calibsignal.eyecaldia);




 