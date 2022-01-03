clc;clear;close all;

n_mf=5;
in_ub=0.6;
in_lb=-0.6;

x=in_lb:0.001:in_ub;
p=zeros(length(x),n_mf);
for i=1:length(x)
       p(i,:)= fuz_front(x(i));
end

figure
subplot(2,1,1)
plot(x,p,'b','LineWidth',1.5);grid on
title('Front wagon fuzzy membership functions')
xlabel('\itInput','FontName','Times New Roman','FontSize',14)
ylabel('\itOutput','FontName','Times New Roman','FontSize',14)



n_mf=5;
in_ub=0.05;
in_lb=-0.05;

x=in_lb:0.001:in_ub;
p=zeros(length(x),n_mf);
for i=1:length(x)
       p(i,:)= fuz(x(i));
end
subplot(2,1,2)
plot(x,p,'b','LineWidth',1.5);grid on
title('Other wagons fuzzy membership functions')
xlabel('\itInput','FontName','Times New Roman','FontSize',14)
ylabel('\itOutput','FontName','Times New Roman','FontSize',14)