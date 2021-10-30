% boxpopboth.m
% b klinger, S12s 2021
% Create size-intensity box plots for population for different ranges of
% temperature and precipitation

% get data if necessary

if ~exist('Tpop')
   getfields
end

% calculate statistics

jj=find(latH>=-60);
Tlo=[-30 -10 0 10 20];
Thi=[-10 0 10 20 30];
Tlo=[-20  0 10 20];
Thi=[  0 10 20 30];
Plo=[ 0 10  40 160];
Phi=[10 40 160 2000];
% Plo=[0:5:400 500:100:1100];
% Phi=[Plo(2:end) 1200];

ntemp=length(Tlo);
nprec=length(Plo);

AAA=zeros(ntemp,nprec);                % area of each bin
PPP=zeros(ntemp,nprec);                % population of each bin

for j=jj
   for itemp=1:ntemp
      ktemp=find(Tann(j,:)>=Tlo(itemp) & Tann(j,:)<Thi(itemp));
      Pannjk=Pann(j,ktemp)/10;     % subset, convert mm --> cm
      for iprec=1:nprec
         kprec=find(Pannjk>=Plo(iprec) & Pannjk<Phi(iprec));
	 kk=ktemp(kprec);
	 AAA(itemp,iprec)=AAA(itemp,iprec)+sum(areaH(j,kk));
	 PPP(itemp,iprec)=PPP(itemp,iprec)+sum(popcH(j,kk));
      end
   end
end
DDD=PPP./AAA;
AAAp=100*AAA/sum(AAA(:));
Dmax=max(DDD');
DmaxI=[2 50 140 80];
DmaxI=[10 80 160 120];

paper([1 3.5])
hold off; clf; top
figprops
icase=5;
hueshadepal
if iyear==1
   D0=[310 300 250 100 0];
   D0=[300 250 100 0];
   yfact=1;
else
   D0=[150 140 100  50 0];
   yfact=2;
end

plot(0,0,'k');
hold on
%%axis([0 45 0 320])
axis([0 45 0 D0(1)+10])
set(gca,'xtick',1:1:44)
set(gca,'ytick',10/yfact:10/yfact:300)
overgrid('[.9 .9 .9]-')
set(gca,'xtick',0:5:45)
set(gca,'ytick',0:50/yfact:300)
set(gca,'yticklabel',[0 50 0 50 100 0 0]/yfact)
overgrid('[.9 .9 .9]-',1.5)

for itemp=1:ntemp
   xwid=AAAp(itemp,:);
   ywid=DDD(itemp,:);
   rectcorn=[0 cumsum(xwid)];
   rectcol=cbsafe(itemp*5+[1:5],:);
   plot([0 45],[1 1]*D0(itemp),'k--');
   plotrect(xwid,ywid,[0 D0(itemp)],rectcorn,rectcol,'k');
end
plot([0 45 45 0 0],[0 0 1 1 0]*(D0(1)+10),'k')
xlabel('Cumulative Land Area (% of total)')
ylabel('Population Density (people/km^2)')
textsiz(12)
title(['(b) Averages for Temperature-Precipitation Bins, ' syear],FS,14)

% color bar

x0=31;
dxc=3;
if iyear==1
   y0=200; dyc=20;
else
   y0=130; dyc=10;
end
rx=[0 1 1 0]; ry=[0 0 1 1];
for jtemp=1:ntemp
   for iprec=1:4;
      col=cbsafe(jtemp*5+iprec,:);
      fill(x0+dxc*(iprec-2+rx),y0-dyc*(jtemp-ry),col);
   end
end
for jtemp=1:4
   text(x0-dxc*1.2,y0-dyc*(jtemp),num2str(Thi(jtemp)),HA,'right')
end
text(x0-dxc*2.25,y0-2.5*dyc,'Temp (^oC)',HA,'center',RO,90)
for iprec=1:3
   text(x0+dxc*(iprec-1),y0+.5*dyc,num2str(Phi(iprec)),HA,'center');
end
text(x0+dxc,y0+1.5*dyc,'Precip (cm/yr)',HA,'center')

