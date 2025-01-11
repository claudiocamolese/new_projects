clc
close all
clear

rng(42)

n = 7; % Cambia questo valore per una dimensione diversa

eingenvalues= zeros(n,n);
eingenvector= zeros(n,n);

% Creazione di una matrice casuale
A = rand(n);

% Rendere la matrice simmetrica
A = (A + A') / 2;
A = [3.7358,  0.4933, -1.3418, -1.7637,  0.2271,  1.2278,  1.5869;
0.4933,  0.2093,  0.0094, -0.7327, -0.1052, -0.0710,  0.4718;
-1.3418,  0.0094,  1.8401,  0.1403, -2.0623, -1.4271,  0.1383;
-1.7637, -0.7327,  0.1403, 13.9561, -2.2388,  1.7600, -3.6215;
0.2271, -0.1052, -2.0623, -2.2388,  5.1934,  0.7312,  0.9980;
1.2278, -0.0710, -1.4271,  1.7600,  0.7312,  1.4996, -0.6847;
1.5869,  0.4718,  0.1383, -3.6215,  0.9980, -0.6847,  2.7000];
% Visualizzazione del risultato
disp('Matrice simmetrica S:');
[vect, lambda]=eigs(A,5, "smallestabs");

disp("primo autovalore e autovettore")

[v1,l1]= inverse_power_method(A);
eingenvector(:,1)=v1;
eingenvalues(1,1)=l1;

I= eye(n,n);
e = zeros(n, 1); % Crea un vettore di zeri lungo n
e(1) = 1;        % Imposta il primo elemento a 1

P1=I-2*(((v1+e)*(v1+e)')/norm(v1+e)^2); %is orthogonal
B1=P1*A*P1;
b1= B1(1,2:end);
A=B1(2:end, 2:end);

n=n-1;

disp("secondo autovalore e autovettore")

[v2_bar,l2]= inverse_power_method(A);
eingenvalues(2,2)=l2;

% if l1 ~=l2
%     alpha= - ((-b1*v2_bar)/(l1-l2));
% else
%     error("I primi due autovalori sono uguali")
% end
alpha= - ((-b1*v2_bar)/(l1-l2));
v2= P1*[alpha;v2_bar];
eingenvector(:,2)=v2;

I= eye(n,n);
e = zeros(n, 1); % Crea un vettore di zeri lungo n
e(1) = 1;        % Imposta il primo elemento a 1

P2_bar=I-2*(((v2_bar+e)*(v2_bar+e)')/norm(v2_bar+e)^2); %is orthogonal

P2 = zeros(n+1); % Matrice di zeri di dimensione (n+1) x (n+1)
P2(1,1) = 1;     % Imposta l'elemento (1,1) a 1
P2(2:end, 2:end) = P2_bar; % Inserisci P nella parte in basso a destra

B2=P2*B1*P2;
b2= B2(2,3:end);
A=B2(3:end, 3:end);


n=n-1;

disp("terzo autovalore e autovettore")
[v3_bar,l3]= inverse_power_method(A);

I= eye(n,n);
e = zeros(n, 1); % Crea un vettore di zeri lungo n
e(1) = 1;        % Imposta il primo elemento a 1

P3_bar=I-2*(((v3_bar+e)*(v3_bar+e)')/norm(v3_bar+e)^2);
P3 = eye(n+2); % Matrice di zeri di dimensione (n+1) x (n+1)
P3(3:end, 3:end) = P3_bar; % Inserisci P nella parte in basso a destra
B3= P3*B2*P3;

if l2 ~=l3 && l1~=l3
    beta=-b2*v3_bar/(l2-l3);
    alpha= - b1*P2_bar*[beta;v3_bar]/(l1-l3);
else
    error("I primi due autovalori sono uguali")
end

v3= P1*P2*[alpha;beta;v3_bar];
eingenvector(:,3)=v3;






