function sys = transformation(data)
%TRANSFORMATION ICS transformation of data.
%
%Harri Hakula, 2019
[p,m] = size(data);
ave = mean( data );
C = cov( data );

L = chol(C, 'Lower');

data = data - repmat(ave, p, 1);

A = L \ data';
as = zeros( p );
for i=1:p
	as(i) = A(:,i)'*A(:,i);
end

F = zeros(m,m);
for k=1:p
	v = data(k,:)';
	F = F + as(k) * (v * v');
end
F = F/((p + 2) * m);

C2 = (L' \ (L \ F));

[V, D] = eig(C2);

Z = data * V;
zc = cov(Z);

DD = spdiags(1 ./ sqrt( diag(zc) ), 0:0, m, m);

G = DD * V';

sys.mean = ave;
sys.pixels = data * G';
sys.lambda = diag(D);
sys.map = @(v)(G \ v + ave');
sys.G = G;
sys.scaling = diag(DD);
end