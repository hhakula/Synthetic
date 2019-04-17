function img = mapper(ta)
%MAPPER Generate a synthetic datum based on the argument transformation.
%
%Harri Hakula, 2019

    [m,n] = size(ta.pixels);
    g = randi(m,[n,1]);
    v = zeros(n,1);
    for k=1:n
        v(k) = ta.pixels(g(k),k);
    end
    
    img = ta.map(v);
end