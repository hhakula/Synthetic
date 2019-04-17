%ta is a struct that contains the transformation.
%Here it is assumed that the data is a 32x32 pixel image.
%In our examples we have augmented the original 28x28 ones to
%this size.
%
%Harri Hakula, 2019 

img = mapper(ta); 
figure(1); image(reshape(img,32,32)')
figure(2); bar3(reshape(img,32,32)')