function [N,XC,YC]=hist2d(X, Y, XC, YC, numContours, energy, maxBinCount)
% 

% University of Illinois Open Source License
% Copyright 2008-2010 Luthey-Schulten Group, 
% All rights reserved.
% 
% Developed by: Luthey-Schulten Group
% 			     University of Illinois at Urbana-Champaign
% 			     http://www.scs.uiuc.edu/~schulten
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the Software), to deal with 
% the Software without restriction, including without limitation the rights to 
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
% of the Software, and to permit persons to whom the Software is furnished to 
% do so, subject to the following conditions:
% 
% - Redistributions of source code must retain the above copyright notice, 
% this list of conditions and the following disclaimers.
% 
% - Redistributions in binary form must reproduce the above copyright notice, 
% this list of conditions and the following disclaimers in the documentation 
% and/or other materials provided with the distribution.
% 
% - Neither the names of the Luthey-Schulten Group, University of Illinois at
% Urbana-Champaign, nor the names of its contributors may be used to endorse or
% promote products derived from this Software without specific prior written
% permission.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL 
% THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
% OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
% OTHER DEALINGS WITH THE SOFTWARE.
%
% Author(s): Elijah Roberts

if nargin < 2
    error('Usage: X Y [XC YC numContours freeEnergy maxBinCount]')
end
if nargin < 3
    XC=10;
end
if nargin < 4
    YC=10;
end
if nargin < 5
    numContours=10;
end
if nargin < 6
    freeEnergy=0;
end
  
% If we just have bin counts, figure out the centers.
if length(XC) == 1
    xbc=XC;
    xmin=min(X);
    xmax=max(X);
    xbw=(xmax-xmin)/(xbc-1);
    XC=[xmin:xbw:xmax];
end
if length(YC) == 1
    ybc=YC;
    ymin=min(Y);
    ymax=max(Y);
    ybw=(ymax-ymin)/(ybc-1);
    YC=[ymin:ybw:ymax];
end

% Create the bins.
N=zeros(length(XC),length(YC));

% Find the bin maxes.
XM=(XC(1:end-1)+XC(2:end))/2;
XM(end+1)=+Inf;
YM=(YC(1:end-1)+YC(2:end))/2;
YM(end+1)=+Inf;

% Bin the data.
for i = 1:length(X)
    if mod(i,1000000) == 0, disp(sprintf('(%04d-%02d-%02d %02d:%02d:%05.02f): Processing data point %d',clock,i)); drawnow('update');, end
    xi=find(XM>=X(i),1,'first');
    yi=find(YM>=Y(i),1,'first');
    N(xi,yi)=N(xi,yi)+1;
end

if nargin >= 7
    N(find(N>maxBinCount))=maxBinCount;
end

return

Z=1.0-(N/max(max(N)));
P=N/(sum(sum(N))*(XC(2)-XC(1))*(YC(2)-YC(1)));
if freeEnergy > 0
    F=-log(P);
else
    F=1.0-(P./max(max(P)));
end
minF=min(min(F));
maxF=max(max(F(find(F<Inf))));
maxF=maxF+maxF*.05;
F(find(F==Inf))=maxF;
if numContours > 0
    contourLevels=[minF:((maxF-minF)/numContours):maxF];
    contourf(XC,YC,F',contourLevels);
else
    image(XC,YC,(1.0-(F./max(max(F))).*length(colormap))');
    set(gca,'YDir','normal');
end

