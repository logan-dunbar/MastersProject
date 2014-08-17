function Error = ComputeError(pixelVal, trajectoryPixelValues)
%COMPUTEERROR Computes the error for a given pixel and trajectory of pixels

Error = sum(bsxfun(@minus, trajectoryPixelValues, pixelVal).^2);

end

