for i = 1:32
    for j=1:32
        tmp = img(((j-1)*16 + 1):j*16, ((i-1)*32 + 1):i*32);
        tmpSal = SpectralResidual(tmp);
        newImg(((j-1)*16 + 1):j*16, ((i-1)*32 + 1):i*32) = tmpSal;
    end
end