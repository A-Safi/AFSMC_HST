function xi=fuz_front(in)

n_mf=5; 
in_ub=0.6;
in_lb=-0.6;

range=(in_ub-in_lb)/(n_mf-1);
C=in_lb:range:in_ub;
Sigma=sqrt((in_ub.^2+in_lb^2)/20);
w=zeros(n_mf,1);

for j=1:n_mf
    w(j)=exp(-((in-C(j))/Sigma)^2);
end

xi=w;

end