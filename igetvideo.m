function [eye,table]=igetvideo(fname)

[x,y,z,o]=smrinfo(fname);
[s1,s2,s3,s4]=smrfilecomment(fname);
freq=str2num(s3);
light=str2num(s4);
table.drumamp=str2num(s1);
table.tableamp=str2num(s2);

data=smrreadADC(fname,'all');
col=[data.ch1.nofsamples;data.ch2.nofsamples;data.ch3.nofsamples;data.ch4.nofsamples;data.ch5.nofsamples];
tmax=min(col)/data.ch1.fsamp;

evnt=SmrReadEvent(fname,8,[0 tmax]);

table.time=linspace(1/data.ch1.fsamp,evnt.ch8.Events(2)-evnt.ch8.Events(1),(evnt.ch8.Events(2)-evnt.ch8.Events(1))*data.ch1.fsamp+1);
table.light=light;
table.freq=freq;
table.sf=x(1,1);

indxstart=evnt.ch8.Events(1)*data.ch1.fsamp;
indxfinish=evnt.ch8.Events(2)*data.ch1.fsamp;

table.table=data.ch1.ADC(indxstart:indxfinish);
table.table=((table.table*0.00015*data.ch1.scale+data.ch1.offset)*-1);
table.drum=data.ch2.ADC(indxstart:indxfinish);
table.drum=((table.drum*0.00015*data.ch2.scale+data.ch2.offset)*-1);

eye.dia=data.ch3.ADC(indxstart+3:indxfinish+3)*data.ch3.scale*0.00015+data.ch3.offset; %+6 for 240 Hz: iscan delay compensation 22s (3=25ms at 120 Hz)
eye.hor=data.ch4.ADC(indxstart+3:indxfinish+3)*data.ch4.scale*0.00015+data.ch4.offset;
eye.ver=data.ch5.ADC(indxstart+3:indxfinish+3)*data.ch5.scale*0.00015+data.ch5.offset;