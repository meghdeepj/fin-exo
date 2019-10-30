%% Assigment 7
%Exercise 9.1

%% FEM
% Variables(0.02,5,0.3,0.7,0.01, 2.1e+11, 0)
    Id = input('Id=');
    m = input('m=');
    a = input('a=');
    b = input('b=');
    d = input('d=');
    E = input('E=');
    rho = input('rho=');
    I = (pi*(d)^4)/64;
    A = pi*(d^2)/4;
    l = a+b;
    A1= rho*A*a/420;
    A2 = rho*A*b/420;
    B1 = E*I/(a^3);
    B2 = E*I/(b^3);
%element1
    I_1 = [m 0 0 0; 0 Id 0 0; 0 0 0 0; 0 0 0 0];
    R_1 = A1*[156 22*a 54 -13*a; 22*a 4*(a^2) 13*a -3*(a^2); 54 13*a 156 -22*a; -13*a -3*(a^2) -22*a 4*(a^2)];
    K_1 = B1*[12 6*a -12*a 6*a; 6*a 4*(a^2) -6*a 2*(a^2); -12*a -6*a 12 -6*a; 6*a 2*(a^2) -6*a 4*(a^2)];
    M_1 = I_1+R_1;
%element2
    I_2 = 0;
    K_2 = B2*[12 6*b -12*a 6*b; 6*a 4*(b^2) -6*b 2*(b^2); -12*b -6*b 12 -6*b; 6*b 2*(b^2) -6*a 4*(l^2)];
    R_2 = A2*[156 22*b 54 -13*b; 22*b 4*(b^2) 13*b -3*(b^2); 54 13*b 156 -22*b; -13*b -3*(b^2) -22*b 4*(b^2)];
    M_2 = I_2 + R_2;
    
%combine elements
    M11= zeros(6,6);
    M11(1:4,1:4) = M_1;
    
    K11= zeros(6,6);
    K11(1:4,1:4) = K_1;
    
    M22= zeros(6,6);
    M22(3:6,3:6) = M_2;
    
    K22= zeros(6,6);
    K22(3:6,3:6) = K_2;
    
    M = M11+M22
    K = K11 + K22

    disp('From boundary conditions Sy1=0, My1=0, My2=0 v2=0 v3=0 phi3=0');
    M(6,:)=[];
    M(:,6)=[];
    M(5,:)=[];
    M(:,5)=[];
    M(3,:)=[];
    M(:,3)=[];
    
    K(6,:)=[];
    K(:,6)=[];
    K(5,:)=[];
    K(:,5)=[];
    K(3,:)=[];
    K(:,3)=[];
    
    D = pinv(M)*K
    [V, E] = eig(D);
    phi_fem= zeros(3,3);
    w_fem = zeros(3,1);
    w_fem(1,1)= sqrt(E(1,1));
    w_fem(2,1) = sqrt(E(2,2));
    w_fem(3,1)= sqrt(E(3,3));
    phi_fem(:,1) = V(:,1)/V(1,1);
    phi_fem(:,2) = V(:,2)/V(1,2);
    phi_fem(:,3) = V(:,3)/V(1,3);
    w_fem
    phi_fem

%% end    
    