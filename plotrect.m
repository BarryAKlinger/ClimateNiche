function plotrect(xwid,ywid,xy0,rectcorn,rectcol,edgecol);
% function plotrect(xwid,ywid,xy0,rectcorn,rectcol,edgecol);
% b klinger, F8R 2018
%
% Function to plot a set of filled rectangles in a line
% (xwid,ywid) = vectors for widths in hor. and vert. directions
% xy0 = [x y] position of corner of 1st rectangle
% rectcorn = vector of corner distances in x (if row) or in y (if col)
% rectcol=rectangle fill colors (each row = letter or RGB numbers)
% edgecol=color of rectangle edges, one color for all or one for each

%---------------------------------------------------------------------
% preliminaries
%---------------------------------------------------------------------

rx=[0 1 1 0 0];
ry=[0 0 1 1 0];
nrect=length(xwid);              % number of rectangles
nxy=size(rectcorn);              % for lining up in one dimension
EC='edgecolor';                  % graphics property name

% determine if there is one color for all rectangle outlines

if length(edgecol)==1,
   onecolor=1;
end

%---------------------------------------------------------------------
% plot rectangles
%---------------------------------------------------------------------

% Set jdim to 1 if rectcorn is row, 2 if column.
% Loop through all rectangles.

jdim=1+sign(floor(nxy(1)/nxy(2))); 
for iR=1:nrect

% Initialize with 1st corner, then add rectcorn to correct dimension.
% Assign current edge color and rename if meant to be "none"

   xxyy=xy0';
   xxyy(jdim)=xxyy(jdim)+rectcorn(iR);
   if exist('onecolor')
      Ecol=edgecol;
   else
      Ecol=edgecol(iR,:);
   end
   if Ecol=='N'; Ecol='none'; end

% Do actual rectangle plot.

   horz=xxyy(1)+xwid(iR)*rx;
   vert=xxyy(2)+ywid(iR)*ry;
   if length(rectcol)==1
      plot(horz,vert,Ecol);
   else
      fill(horz,vert,rectcol(iR,:),EC,Ecol);
   end
   hold on
end
