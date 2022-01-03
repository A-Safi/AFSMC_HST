clear
clc
color='b-';
ds=genpath(pwd);
addpath(ds);

%% Defining parameters
m = 80000;
k = 80000;

c0 = 0.01176;
c1 = 0.00077616;
c2 = 0.000016;


lk=1.2; %Free tension
lkd=-1.2; %Desire reletive displacment
b=3.38; %Width of Train's cars
L=25; %Length of Train's cars
n=12;
ln=6;

h=0.1; %solution's timestep
tf=970; %solution's endtime %max simulation time 960sec
time=(0:h:tf)'; %time's vector
tf_display=tf;

%%  Cache
x=zeros(length(time),2*ln);
u=zeros(length(time),ln);
xd=zeros(length(time),n);
k1=zeros(size(x));
k2=zeros(size(x));
k3=zeros(size(x));
k4=zeros(size(x));

%% initial values
v_start=20;
x(1,:)=[0;-lk;-lk;-lk;-lk;-lk;v_start;0;0;0;0;0]';

%% Desire
run('Desire.m')
% load('desire.mat');

%% Adaptation Parameters
gamma=[0.02,1,1,1,1,1]*500;
alpha=[0.2,1,1,1,1,1]*100;
lambda=[0.01,1,1,1,1,1]*1;

B=repmat([-3,-2,0,2,3]',1,6);


%% First time run
% p=ones(6);
% psi=ones(1,6);

%% Run
load('Results/P_Psi_initial.mat')

%%
p=reshape(p,[1,36]);

%% Runge Kutta for system dynamics
for i=1:length(time)-1
    %%
    if i > j*length(time)/100
        clc
        progres=sprintf('%d%%',floor(100*i/length(time)));
        disp(progres)
        j=j+1;
    end
    
    [dp,dpsi,u(i,:)]=Control(x_desire(i,:),x(i,:),p(i,:),psi(i,:),alpha,gamma,lambda,B);
    p(i+1,:)=p(i,:)+dp*h;
    psi(i+1,:)=psi(i,:)+dpsi*h;
%     u(i,:)=zeros(1,6);
    %%
    k1=odefunc(x(i,:),u(i,:),lk,[m m m m m m],[c0,c1,c2],k)';
    k2=odefunc(x(i,:)+h/2*k1,u(i,:),lk,[m m m m m m],[c0,c1,c2],k)';
    k3=odefunc(x(i,:)+h/2*k2,u(i,:),lk,[m m m m m m],[c0,c1,c2],k)';
    k4=odefunc(x(i,:)+h*k3,u(i,:),lk,[m m m m m m],[c0,c1,c2],k)';
    
    x(i+1,:)=x(i,:)+h/6*(k1+2*k2+2*k3+k4);
    
    %% Noise
%     x(i+1,7)=x(i+1,7)+0.1*randn(1);
%     x(i+1,8:12)=x(i+1,8:12)+0.01*randn(1,5);
end
y(:,1)=x_desire(:,1)-x(:,1);
y(:,2:6)=x(:,2:6)-x_desire(:,2:6);

y(:,7)=x_desire(:,7)-x(:,7);
y(:,8:12)=x(:,8:12)-x_desire(:,8:12);

s=y(:,7:12)+lambda.*y(:,1:6);
%% figures
run('FigurePloter.m');

%% Saving parameteres
% psi=psi(end,:);p=reshape(p(end,:),[6,6]);
% save('Results\P_Psi_initial.mat','p','psi')
% save('Results\desire.mat','x_desire')
%%
rmpath(ds);