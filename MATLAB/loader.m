%It is assumed that d4.mat contains the MNIST data for the digit 4.
%Harri Hakula, 2019 
load d4.mat;
data = Expression1;

[m,n] = size(data);

noise = 1 + rand(m, n);
data = data + noise;

ta = transformation(data);
