% conpop3temp.m
% b klinger, S13s 2021
% Contour hybrid of temperature and population density, using
% variables from getfields.m

% Mscripts used:
% This project: getfields, conglobecos, cosgrid
% Klinger archive: smooth3, figprops, contourfP, overgrid, originx

if ~exist('popdH') | ~exist('Tann')
   getfields
   densX=smooth3(popdH,ones(3,3)/9);
end

% create hybrid variable for temperature and log10 population

if ~exist('Tdens')
   jj=find(latH>=-50 & latH<=60);
   latj=latH(jj);
   Tdens=floor(Tann(jj,:)/10)*10+0*popdH(jj,:)*0;
   njj=length(jj);
   for j=1:njj
      i1=find(Tdens(j,:)<0);
      Tdens(j,i1)=-10;
   end
   dj=jj(1)-1;
   densHi=[1 10 100 1000 1e6]/6;
   densLo=[-1  1  10 100 1000]/6;
   for j=jj
      for k=1:5
         ibin=find(densX(j,:)<=densHi(k) & densX(j,:)>densLo(k));
	 Tdens(j-dj,ibin)=Tdens(j-dj,ibin)+k;
      end
   end
end


% some graphics parameters

figprops
ci=[-9.5:-5.5  .5:4.5  10.5:14.5  20.5:25.5];
cbrk=[.5 10.5 20.5];
col='ABGN';
for i=1:5
   xlohi(i,:)=[.1 1];
end

% choose colors

colB=[ 50  50  50
      117 112 179
       27 158 119
      217  95  2];
colB=colB/255;
wh=[1 1 1];
bk=[0 0 0];
cbsafe=colorpal([col 'x'],[5 5 5 5],xlohi);
i=2;
xfrac=.1;
cbsafe(3+(i-1)*5,:)=colB(i,:)*(1-xfrac)+xfrac*wh;
xfrac=1/3;
xfrac=.45;
cbsafe(5+(i-1)*5,:)=colB(i,:)*(1-2*xfrac)+2*xfrac*bk;
cbsafe(1+(i-1)*5,:)=colB(i,:)*(1-2*xfrac)+2*xfrac*wh;
xfrac=1/6;
xfrac=1/4;
cbsafe(4+(i-1)*5,:)=colB(i,:)*(1-1.5*xfrac)+1.5*xfrac*bk;
cbsafe(2+(i-1)*5,:)=colB(i,:)*(1-2*xfrac)+2*xfrac*wh;


%---------------------------------------------------------------------
paper([0 3.5])
hold off; clf; figure(gcf)
%---------------------------------------------------------------------

% Use special cos land projection for contour graph of hybrid variable

[xx,ii,yy]=conglobecos(lonH,latj);
contourfP(xx.Am,yy.Am,Tdens(:,ii.Am),ci,col,cbrk,'none',.5,xlohi);
hold on
contourfP(xx.Af,yy.Af,Tdens(:,ii.Af),ci,col,cbrk,'none',.5,xlohi);
contourfP(xx.As,yy.As,Tdens(:,ii.As),ci,col,cbrk,'none',.5,xlohi);
contour(xx.Am,yy.Am,isnan(popdH(jj,ii.Am)),[.5 .5],'k');
contour(xx.Af,yy.Af,isnan(popdH(jj,ii.Af)),[.5 .5],'k');
contour(xx.As,yy.As,isnan(popdH(jj,ii.As)),[.5 .5],'k');

% grids

axis equal;
axis([-85 145 -50 60])
cosgrid
set(gca,'ytick',-45:15:60)
overgrid('[.7 .7 .7]-')
originx

% color bar

rx=[0 1 1 0]; ry=[0 0 1 1];
for i=1:4;
   for j=1:5
      fill(60+7*(j+rx),-20-5*(i+ry),cbsafe(j+(i-1)*5,:));
   end
end
text(66,-30,'0',HA,'right')
text(66,-35,'10',HA,'right')
text(66,-40,'20',HA,'right')
text(61,-35,'temp (^oC)','rotation',90,HA,'center')
text(67+7,-22.5,'1',HA,'center')
text(67+2*7,-22.5,'10',HA,'center')
text(67+3*7,-22.5,'100',HA,'center')
text(67+4*7,-22.5,'1000',HA,'center')
text(67+2.5*7,-17.5,'people/km^2',HA,'center')

colormap(cbsafe)
textsiz(6)
title('Annual Mean T and Population Density',FS,10)

