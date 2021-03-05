function U_ab = customrand(a,b,m,n)
%produce data U_ab ~ U(a,b)
%U_ab is a  m x n matrix

U_ab = (b-a) * rand(m,n) + a;

end

