figprops
latgrid=-50:60;
latN=25:60;
dxAsia=110+(60-110)*cosd(25) - (20 + (60-20)*cosd(25));
loncen=[-80+30 20 110-dxAsia];
lonwid=[50 40 50];

longrid0=[-120 -90 -60   0 30 60   60 90 120 150];
longrid=longrid0;
longrid(1:3)=longrid(1:3)+30;
longrid(7:10)=longrid(7:10)-dxAsia;
jG=[1 1 1 2 2 2 3 3 3 3];
ngrid=length(longrid);
for i=1:ngrid
   LG=loncen(jG(i));
   plot(LG+(longrid(i)-LG)*cosd(latgrid),latgrid,'color',[1 1 1]*.7)
   text(LG+(longrid(i)-LG)*cosd(-50),-53,num2str(longrid0(i)),HA,'center')
end

for i=1:3
   if i>1
      plot(loncen(i)+lonwid(i)*cosd(latgrid),latgrid,'k')
   end
   if i==1
      plot(loncen(i)-lonwid(i)*cosd(latgrid),latgrid,'k')
   elseif i==3
      plot(loncen(i)-lonwid(i)*cosd(latN),latN,'k')
   end
end

set(gca,'xtick',[])

   
