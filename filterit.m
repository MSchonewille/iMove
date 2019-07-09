function data=filterit(data,samplefreq,cutoff)

warning off;
buttercut=cutoff/(samplefreq/2);
[x,y]=butter(4,buttercut);
data=filtfilt(x,y,data);
warning on;
disp('filterit');

