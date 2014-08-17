function Gradients = ComputeGradients(pixelError, neighbourPixelErrors)
%COMPUTEGRADIENTS Computes the gradients for a given pixel and its
%neighbours's errors

Gradients = bsxfun(@minus, neighbourPixelErrors, pixelError);

end

