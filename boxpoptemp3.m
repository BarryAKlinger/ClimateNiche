% boxpoptemp3.m
% b klinger, S12s 2021
% Bin pixels together that are in same temperature range
% and integrate area and population - this version uses HYDE population

%---------------------------------------------------------------------
% calculations
%---------------------------------------------------------------------

% get data if necessary

if ~exist('Tpop')
%   getsevdata
   getfields
end

% calculate statistics

jj=find(latH>=-60 & latH<=80);
Tbin=[-28:2:32]-1;                % temperature bins
nbin=length(Tbin);
AAA=zeros(1,nbin);                % area of each bin
PPP=zeros(1,nbin);                % population of each bin

% loop through each latitude, each longitude land point,
% accumulate sums for area and population

for j=1:length(jj)
   jk=jj(j);
   iland=find(isnan(popdH(jk,:)+Tann(jk,:))==0);
   jbin=ceil((Tann(jk,iland)+30)/2);
   for i=1:length(iland)
      ik=iland(i);
      AAA(1,jbin(i))=AAA(1,jbin(i))+areaH(jk,ik);
      PPP(1,jbin(i))=PPP(1,jbin(i))+popcH(jk,ik);
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

hueshadepal          % create color palette

% parameters that depend on which year is chosen

if iyear==1;
   ytop=150;
   dybig=25;
   dylit=5;
   slett='(a)  ';
elseif iyear==2
   ytop=100;
   dybig=5;
   dylit=1;
   slett='';
elseif iyear==3
   ytop=30;
   dybig=5;
   dylit=1;
   slett='(b)  ';
end

%---------------------------------------------------------------------
% Do plot
%---------------------------------------------------------------------

% grid and box plot

axes('position',[.13 .3 .7750 .6])
plot(0,0,'k')
hold on
axis([0 140 0 ytop])
%%yscale=5;
%%fill([20 40 40 20 20],100+[0 0 yscale yscale 0],[.3 .5 .5])
set(gca,'xtick',2:2:138)
set(gca,'ytick',dylit:dylit:ytop-dylit)
overgrid('[.95 .95 .95]-',.25)
set(gca,'xtick',0:20:140)
set(gca,'ytick',0:dybig:ytop)
overgrid('[.85 .85 .85]-',1)
plotrect(AAA/1e6,DDD,[0 0],rectcorn/1e6,rectcol,'k');
%%plotrect(AAA/1e6,DDD,[0 0],rectcorn/1e6,1,'k');
plot([0 140 140 0 0],[0 0 ytop ytop 0],'k')
if 1==2
   plot([20 40 40 20 20],100+[0 0 yscale yscale 0],'k',LW,1.5)
   plot([30 30],100+[0 yscale],'k',LW,1.5)
   for i=0:2
      text(20+10*i,95,num2str(i*10),HA,'center')
   end
   text(30,87.5,'area (10^6 km^2)',HA,'center')
end
for xx=2:2:138;
   plot([xx xx],[0 dylit/2],LW,.25,'color',[1 1 1]*.9)
end
for xx=20:20:120
   plot([xx xx],[0 dylit],LW,1,'color',[.9 .9 .9])
end

% annotation

%%xlabel('cumulative area (10^6 km^2)')
text(70,-.8*dybig,'cumulative area (10^6 km^2)',HA,'center')
ylabel('density (people/km^2)')
title([slett 'Population Density by Temperature Range, Year ' syear])
if 1==2
sTrange={'0-10^oC' '10-20^oC' '20-30^oC'};
for jten=1:3
   ii10=find(Tbin>=(jten-1)*10 & Tbin<=jten*10);
   sumP=round(100*sum(PPP(ii10))/sum(PPP));
   disp([sum(AAA(ii10))/1e6 mean(DDD(ii10)) sum(PPP(ii10))/1e9])
   yy=(1.75+jten/2)*dybig;
   text(5,yy,[sTrange{jten} ':'])
   text(39,yy,[num2str(sumP) '%'],HA,'right')
end
text(39,3.75*dybig,'\bf Population',HA,'right')
end

% Temperature scale

densScale=125;
densScale=(9/12)*ytop;
dyscale=ytop/15;
xSleft=70;
for i=11:31
   fill(xSleft+3.2*(i-11+rx),densScale+dyscale*ry,cbsafe(i,:))
   Tlab=Tbin(i)-1;
   if Tlab/10==round(Tlab/10)
      text(xSleft+3.2*(i-11),densScale-.7*dyscale,num2str(Tlab),HA,'center')
   end
end
text(xSleft+10*3.2,densScale+2*dyscale,'temperature (^oC)',HA,'center')
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
