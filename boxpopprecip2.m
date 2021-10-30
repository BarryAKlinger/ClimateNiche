% boxpopprecip2.m
% b klinger, S12s 2021
% Bin pixels together that are in same precipitation range
% and integrate area and population - this version uses HYDE population

%---------------------------------------------------------------------
% calculations
%---------------------------------------------------------------------

% get data if necessary

if ~exist('Tpop')
   getfields
end

% calculate statistics

jj=find(latH>=-60 & latH<=80);
Pbin=[0:10:40 80:40:200 300:100:1200];
Pbin=[0:10:160 180:20:1200];
Pbin=[0:10:80 100:20:160 200:40:320 480 640 800 960];
nbin=length(Pbin);
AAA=zeros(1,nbin-1);                % area of each bin
PPP=zeros(1,nbin-1);                % population of each bin

% loop through each latitude, each longitude land point,
% accumulate sums for area and population

for j=1:length(jj)
   jk=jj(j);
   iland=find(isnan(popdH(jk,:)+Pann(jk,:))==0);
   Pland=Pann(jk,iland)/10;
   for jbin=1:nbin-1
      kbin=find(Pland>=Pbin(jbin) & Pland<Pbin(jbin+1));
      AAA(1,jbin)=AAA(1,jbin)+sum(areaH(jk,iland(kbin)));
      PPP(1,jbin)=PPP(1,jbin)+sum(popcH(jk,iland(kbin)));
   end
end
DDD=PPP./AAA;                     % population density of each bin
rectcorn=[0 cumsum(AAA)];

%---------------------------------------------------------------------
paper([1.5 3.5])
hold off; clf; top
%---------------------------------------------------------------------

figprops
rx=[0 1 1 0 0];
ry=[0 0 1 1 0];

%---------------------------------------------------------------------
% Some graphics parameters
%---------------------------------------------------------------------

icase=3;
hueshadepal          % create color palette

% parameters that depend on which year is chosen

if iyear==1;
   ytop=100;
   dybig=20;
   dylit=5;
elseif iyear==2
   ytop=100;
   dybig=5;
   dylit=1;
elseif iyear==3
   ytop=30;
   dybig=5;
   dylit=1;
end

%---------------------------------------------------------------------
% Do plot
%---------------------------------------------------------------------

% grid and box plot

axes('position',[.13 .3 .7750 .6])
plot(0,0,'k')
hold on
axis([0 140 0 ytop])
set(gca,'xtick',5:5:135)
set(gca,'ytick',dylit:dylit:ytop-dylit)
overgrid('[.9 .9 .9]-')
set(gca,'xtick',0:20:140)
set(gca,'ytick',0:dybig:ytop)
overgrid('[.7 .7 .7]-')
plotrect(AAA/1e6,DDD,[0 0],rectcorn/1e6,rectcol,'k');

% annotation

xlabel('cumulative area (10^6 km^2)')
ylabel('density (people/km^2)')
title(['Population Density by Precipitation Range, Year ' syear])
sTrange={'0-40' '40-80' '80-160' '160-320' '320-1200'};
iiLo=[1 5  9 17 25];
iiHi=[4 8 16 24 68];

if 1==2
sTrange={'0-40' '40-80' '80-160' '160-320' '320-640' '640-1280'};
iiLo=[1:4:21];
iiHi=[5:4:25];
for i10=1:length(iiLo)
   ii10=iiLo(i10):iiHi(i10)-1;
   sumP=round(100*sum(PPP(ii10))/sum(PPP));
   yy=(.75+i10/2)*dybig;
   text(5,yy,['\bf ' sTrange{i10} ':'],'color',rectcol(4*i10,:))
   text(49,yy,['\bf ' num2str(sumP) '%'],HA,'right','color',rectcol(4*i10,:))
end
text(50,4.25*dybig,'\bf % of Total Pop.',HA,'right')
end

% Temperature scale

densScale=125;
densScale=(4/5)*ytop;
dyscale=ytop/15;
dxscale=3.25;
xSleft=5;
ncol=length(rectcol);
for i=1:ncol
   fill(xSleft+dxscale*(i-rx),densScale+dyscale*ry,cbsafe(i,:))
   Plab=Pbin(i+1);
   if i/4==round(i/4)
      text(xSleft+dxscale*(i),densScale-.7*dyscale,num2str(Plab),HA,'center')
   end
end
text(xSleft,densScale-.7*dyscale,'0',HA,'center')
text(xSleft+dxscale*(ncol+2)/2,densScale+1.7*dyscale,'Precip (cm/yr)',HA,'center')
textsiz(12)

axes('position',[.13 .1 .7750 .05])
xwid=100*PPP/sum(PPP);
rectcorn=cumsum([0 xwid]);
xy0=[0 0];
ywid=00*xwid+1;
plotrect(xwid,ywid,xy0,rectcorn,rectcol,'k');
axis([0 100 0 1])
set(gca,'ytick',[])
set(gca,'xtick',[0:20:100])
for xx=5:5:95
   plot([xx xx],[1/32 3/8],'w',LW,.25)
end
for xx=20:20:90
   plot([xx xx],[1/32 1/2],'w',LW,1)
end
xlabel('cumulative population (% of total)')
textsiz(12)
