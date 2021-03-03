function N_mu_sigma = customrandn(mu,sigma,m,n)
%produce data N_mu_sigma ~ N(mu,sigma)
%N_mu_sigma is a  m x n matrix

N_mu_sigma = sigma * randn(m,n) + mu;

end



