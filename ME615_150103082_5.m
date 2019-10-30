%% 150103082 Assignment 5

% Ques 7.10 of book
%% Define variables

    %(0.002,200,0.5,0.01,7800,0.8e+11)
    Ip = input('Ip=');
    kt = input('kt=');
    L = input('L=');
    d = input('d=');
    rho = input('rho=');
    G = input('G=');
    l=L/2;
    J=(pi*(d)^4)/32;
%% FEM

    %shaft divided into two elements
    c1=rho*J*l/6;
    c2=G*J/l;
    
    disp('FEM method:');
    
    % element1
    M1= c1*[2 1;1 2];
    I1= [Ip 0; 0 0];
    K1 = c2*[1 -1; -1 1];
    Kt1 = [200 0; 0 0];
   
    % element 2
    M2 = c1*[2 1; 1 2];
    I2= [0 0; 0 Ip];
    K2 = c2*[1 -1; -1 1];
    Kt2 = [0 0; 0 200];
    
    % make compatible
    M11= zeros(3,3);
    M11(1:2,1:2) = M1;
    
    K11= zeros(3,3);
    K11(1:2,1:2) = K1;

    M22= zeros(3,3);
    M22(2:3,2:3) = M2;

    K22= zeros(3,3);
    K22(2:3,2:3) = K2;
    
    I11= zeros(3,3);
    I11(1:2,1:2) = I1;
    
    Kt11= zeros(3,3);
    Kt11(1:2,1:2) = Kt1;

    I22= zeros(3,3);
    I22(2:3,2:3) = I2;

    Kt22= zeros(3,3);
    Kt22(2:3,2:3) = Kt2;

    %add
    M = M11 + M22;
    I = I11 + I22;
    K = K11 + K22;
    Kt = Kt11 + Kt22;
    
    M = M + I;
    K = K + Kt;
    
    disp('Boundary condition: T1=0, T3=0');
    
    %eigenvalue problem
    D = pinv(M)*K;
    [V, E] = eig(D);
    phi_fem= zeros(3,3);
    w_fem = zeros(3,1);
    w_fem(1,1)= sqrt(E(1,1));
    w_fem(2,1) = sqrt(E(2,2));
    w_fem(3,1)= sqrt(E(3,3));
    phi_fem(:,1) = V(:,1)/V(1,1);
    phi_fem(:,2) = V(:,2)/V(1,2);
    phi_fem(:,3) = V(:,3)/V(1,3);
    
    %outputs
    w_fem;
    phi_fem;
%% TMM

    disp('TMM Method:');
    k=G*J/L;
    syms w_nf;
    %transfer matrices
    F_1 = [1 1/kt; 0 1];
    P_1 = [1 0; -Ip*(w_nf)^2 1];
    U_2 = [1 1/k; -Ip*(w_nf)^2 1-(Ip*(w_nf)^2)/k];
    F_3 = [1 1/kt; 0 1];
    
    %final matrix
    LS3= F_3*U_2*P_1*F_1;
    
    disp('From boundary conditions, t12 = 0');
    
    wnf_eqn = LS3(1,2) == 0;
    
    w_tmm = solve(wnf_eqn, w_nf);
    
    w_tmm = [w_tmm(4); w_tmm(2)];
    %w_nf value
    w_tmm = double(w_tmm);
    
    disp('For mode shapes take equation t22 for w_nf1 and w_nf2');
    LS3(2,2);
    phi_tmm(1:2,1:2) = 1;
    
    %phi_tmm for two modes
    w_nf=w_tmm(1);
    phi_tmm(2,1)= subs(LS3(2,2));
    w_nf=w_tmm(2);
    phi_tmm(2,2)= subs(LS3(2,2));
    
    %ouput
    phi_tmm;  
  
%end of code