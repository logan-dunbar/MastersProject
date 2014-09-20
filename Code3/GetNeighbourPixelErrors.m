function NeighbourPixelErrors = GetNeighbourPixelErrors(index, errorMap, trajColSz, trajNeighbourIndices, trajIndsCount)
%GETNEIGHBOURPIXELERRORS Gets the neighbouring pixel errors for a given
%index, padding the edge with a copy of the indexed pixel error so as to
%produce a gradient of 0 going out the edges.

pixelError = errorMap(index);
NeighbourPixelErrors(1:8) = pixelError;

% Left
if (index <= trajColSz)
    % Top
    if (mod(index, trajColSz) == 1)
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
        NeighbourPixelErrors(8) = errorMap(index + trajNeighbourIndices(8));
    % Bottom
    elseif (mod(index, trajColSz) == 0)
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
        NeighbourPixelErrors(6) = errorMap(index + trajNeighbourIndices(6));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
    % Middle
    else
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
        NeighbourPixelErrors(6) = errorMap(index + trajNeighbourIndices(6));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
        NeighbourPixelErrors(8) = errorMap(index + trajNeighbourIndices(8));
    end
% Right
elseif (index > trajIndsCount - trajColSz)
    % Top
    if (mod(index, trajColSz) == 1)
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(3) = errorMap(index + trajNeighbourIndices(3));
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
    % Bottom
    elseif (mod(index, trajColSz) == 0)
        NeighbourPixelErrors(1) = errorMap(index + trajNeighbourIndices(1));
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
    % Middle
    else
        NeighbourPixelErrors(1) = errorMap(index + trajNeighbourIndices(1));
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(3) = errorMap(index + trajNeighbourIndices(3));
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
    end
% Middle
else
    % Top
    if (mod(index, trajColSz) == 1)
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(3) = errorMap(index + trajNeighbourIndices(3));
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
        NeighbourPixelErrors(8) = errorMap(index + trajNeighbourIndices(8));
    % Bottom
    elseif (mod(index, trajColSz) == 0)
        NeighbourPixelErrors(1) = errorMap(index + trajNeighbourIndices(1));
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
        NeighbourPixelErrors(6) = errorMap(index + trajNeighbourIndices(6));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
    % Middle
    else
        NeighbourPixelErrors(1) = errorMap(index + trajNeighbourIndices(1));
        NeighbourPixelErrors(2) = errorMap(index + trajNeighbourIndices(2));
        NeighbourPixelErrors(3) = errorMap(index + trajNeighbourIndices(3));
        NeighbourPixelErrors(4) = errorMap(index + trajNeighbourIndices(4));
        NeighbourPixelErrors(5) = errorMap(index + trajNeighbourIndices(5));
        NeighbourPixelErrors(6) = errorMap(index + trajNeighbourIndices(6));
        NeighbourPixelErrors(7) = errorMap(index + trajNeighbourIndices(7));
        NeighbourPixelErrors(8) = errorMap(index + trajNeighbourIndices(8));
    end
end

end

