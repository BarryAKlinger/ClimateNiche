% getfields.m
% b klinger, S12s 2021
% Get population data from HYDE and geophysical data from WorldCLIM.

%---------------------------------------------------------------------
% population
%---------------------------------------------------------------------

% Load data from user-selected year
% Data files (.mat) are taken directly from .asc files 
% downloaded from https://www.pbl.nl/en/image/links/hyde.

if ~exist('popcH')

if ~exist('lonH1')
   iyear=input('1: 2000, 2: 1900, 3: 1800? ');
   syear=[num2str(2100-100*iyear)];
   eval(['load ..\Hyde\popc_' syear 'AD.mat'])
   eval(['load ..\Hyde\popd_' syear 'AD.mat'])
   lonH1=lon;
   latH1=lat;
   scent=num2str(21-iyear);
   eval(['popc = popc' scent ';'])
   eval(['popd = popd' scent ';'])
   eval(['clear popc' scent ' popd' scent])
   clear lon lat
end

% replace ocean/no-data value of -9999 w/ versions w/ NaN or 0

nnH1=size(popc);
popcN1=replacenan(popc,-9999,2);    % -9999 ==> NaN
popcZ1=replacenan(popcN1,0,1);      % NaN ===> 0
popdN1=replacenan(popd,-9999,2);    % -9999 ==> NaN
popdZ1=replacenan(popdN1,0,1);      % NaN ===> 0
areaZ1=popcZ1./popdZ1;

% create lower resolution version of popc

ii=2:2:nnH1(2);
jj=2:2:nnH1(1);
lonH=(lonH1(ii)+lonH1(ii-1))/2;
latH=(latH1(jj)+latH1(jj-1))/2;
arealatH1=cosd(latH1)*(111/12)^2;
areaH1=arealatH1'*ones(1,nnH1(2));
for j=1:nnH1(1)
   iG=find(~isnan(areaZ1(j,:)));
   areaH1(j,iG)=areaZ1(j,iG);
end
popcH=popcZ1(jj,ii)+popcZ1(jj,ii-1)+popcZ1(jj-1,ii)+popcZ1(jj-1,ii-1);

% Create mask for popcH, NaN for sea, 1 for land.
% Create population density and area for new grid.

iplus=[0 -1  0 -1];
jplus=[0  0 -1 -1];
popcH=0;
popdH=0;
areaH=0;
for k=1:4
   ip=iplus(k);
   jp=jplus(k);
   pLand(:,:,k)=~isnan(popcN1(jj+jp,ii+ip));
   popcH=popcH+popcZ1(jj+jp,ii+ip);
%%   popdH=popdH+popdZ1(jj+jp,ii+ip);
   areaH=areaH+areaH1(jj+jp,ii+ip).*pLand(:,:,k);
end
pgland=sign(sum(pLand,3));
maskH=replacenan(pgland,0,2);
popdH=popcH./areaH;

% Remove variables from 1/12 degree grid & intermediate variables.

iremove=1;
if iremove==1
   clear lonH1 latH1 areaZ1 areaH1
   clear popcN1 popcZ1 popdN1 popdZ1 popc popd
   clear ii jj arealatH1 iG k iplus jplus
end

end

%---------------------------------------------------------------------
% surface temperature & precipitation
%---------------------------------------------------------------------

% data from https://www.worldclim.org/data/bioclim.html

if ~exist('Tann')
   cd c:\datasets\WorldCLIM
   Tann=imread('wc2.1_10m_bio_1.tif');
   Pann=imread('wc2.1_10m_bio_12.tif');
   GeoKeysT=imfinfo('wc2.1_10m_bio_1.tif');   % not really necessary
   lonT=-180+(1/6)*[.5:2160];
   latT=90-(1/6)*[.5:1080];
   Tann=double(Tann);
   Tann=replacenan(Tann,Tann(1,1),2);
   Pann=double(Pann);
   Pann=replacenan(Pann,Pann(1,1),2);
   cd c:\baksocial\PopClimate
end
