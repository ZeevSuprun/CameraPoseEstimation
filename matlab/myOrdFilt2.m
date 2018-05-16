function map = myOrdFilt2(originalMap, wndSize)
% Helper function for harris_corners.
% gets the largest element in a kernel
 
map = zeros(size(originalMap));
 
numRows = size(originalMap,1);
numCols = size(originalMap,2);
 
d2 = floor(wndSize/2);
d1 = wndSize - d2 - 1;
 
for row = 1:numRows
    for col = 1:numCols
        r1 = row - d1;
        r2 = row + d2;
        c1 = col - d1;
        c2 = col + d2;
        if r1 < 1
            r1 = 1;
        end
        if r2 > numRows
            r2 = numRows;
        end
        if c1 < 1
            c1 = 1;
        end
        if c2 > numCols
            c2 = numCols;
        end
        window = originalMap(r1:r2,c1:c2);
        wndwMax = max(max(window));
        map(row, col) = wndwMax;
    end
end
 
end