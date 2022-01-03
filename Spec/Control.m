function [p_d,psi_d,u]=Control(x_desire,x,p,psi,alpha,gamma,lambda,B)
S_front=saturation([-0.6,0.6]);
S=saturation([-0.05,0.05]);

p=reshape(p,[6,6])';

y(1)=x_desire(1)-x(1);
y(2:6)=x_desire(2:6)-x(2:6);

y(7)=x_desire(7)-x(7);
y(8:12)=x_desire(8:12)-x(8:12);

s=y(7:12)+lambda.*y(1:6);
ss=evaluate(S,s')';
ss(1)=evaluate(S_front,s(1)')';
Ws=[fuz_front(ss(1)) fuz(ss(2)) fuz(ss(3)) fuz(ss(4)) fuz(ss(5)) fuz(ss(6))];

ufuz=sum(p*diag((B'*Ws)./repmat(sum(Ws,1),6,1)),2)';
ur=psi.*s;
u=(ufuz+0*ur);

p_d=gamma.*s.*diag(B'*Ws./repmat(sum(Ws,1),6,1));
psi_d=alpha.*abs(s);
p_d=reshape(p_d,[1,36]);
end