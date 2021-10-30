function [xx,ii,yy]=conglobecos(lon,lat);

ny=length(lat);

ii.Am=find(lon>=-130 & lon<-30);
ii.Af=find(lon>=-20 & lon<60);
ii.As=find(lon>=60 & lon<160);
dxAsia=110+(60-110)*cosd(25) - (20 + (60-20)*cosd(25));
for j=1:ny
   xx.Am(j,:)=-80+(lon(ii.Am)+80)*cosd(lat(j))+30;
   xx.Af(j,:)=20+(lon(ii.Af)-20)*cosd(lat(j));
   xx.As(j,:)=110+(lon(ii.As)-110)*cosd(lat(j))-dxAsia;
end
nn=size(lat);
if nn(1)==1
   lat=lat';
end
yy.Am=lat*ones(1,length(ii.Am));
yy.Af=lat*ones(1,length(ii.Af));
yy.As=lat*ones(1,length(ii.As));
