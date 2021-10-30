% color palette (qualitative colorblnd-safe from colorbrewer):

if ~exist('icase')
   icase=1;
end
if icase==1
   hue='AAABGNA';
   nshade=5;
elseif icase==2
   hue='ANGBAA';
   nshade=4;
elseif icase==3
   hue='ANGBB';
   nshade=4;
elseif icase==5
   hue='AABGN';
   nshade=5;
end
nhue=length(hue);
for i=1:nhue
   xlohi(i,:)=[.1 .8];
end
nColAll=ones(1,nhue)*nshade;
cbsafe=colorpal([hue 'x'],nColAll,xlohi);
cbsafe1=cbsafe;
clf

% turn blues into purples

colB=[117 112 179]/255;
wh=[1 1 1];
bk=[0 0 0];
i=strfind(hue,'B');
i=i(1);
ibase=nshade*(i-1);
if icase==1
   xfrac=[.9 .5 0 .25 .45];
   imix= [ 1  1 1  0   0];
else
   xfrac=[.9 .5 .25 .45];
   imix=[1 1 0 0];
end
for jshade=1:length(xfrac)
   xf=xfrac(jshade);
   cbsafe(ibase+jshade,:)=(1-xf)*colB+xf*imix(jshade)*wh;
end

rectcol=cbsafe;
