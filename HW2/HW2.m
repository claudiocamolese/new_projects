clc
close all
clear

rng(42)

% Carica i dati
load('Circle.mat'); % Supponiamo che il file contenga una variabile X

% Parametri
k_values = [10];
num_connected_components=zeros(3,1);
i=1;
%Il parametro k specifica il numero di vicini più prossimi che devono essere 
% considerati per ogni punto quando si costruisce il grafo k-NN. Un valore più alto di kk significa 
% che il grafo conterrà più connessioni per ogni punto, mentre un valore più basso creerà 
% un grafo più "sparso".


for k = k_values

    W= knn_graph(X,k);

    [L,D,W]= LDW(W); %from now on, matrices are sparses
    Lsym= compute_Lsym(L,D);

    %fare un confronto tra L e Lsym
    [num_connected_components(i),eigenvectors, eigenvalues]= num_connect_comp(Lsym); %dovrebbero essere 3?
    % problems:
    % - num_conn_comp= [2,1,1] dobbiamo usare questo come clusters? Non
    % dovrebberp essere 3?

    % - usare inv power method + deflation

    %check what value of M to use by watching these graphs
    figure
    subplot(2,2,1)
    plot(linspace(1,20,20), diag(eigenvalues), MarkerIndices=6)
    hold on;
    plot(linspace(1,20,20), diag(eigenvalues), 'ro', 'MarkerFaceColor', 'w');  % Pallini rossi sugli autovalori
    xlabel('Index');
    ylabel('Value');
    grid on
    title(sprintf("eingenvalues k=%g", k))

    subplot(2,2,2)
    plot(linspace(1,20,20), diag(eigenvalues)/max(diag(eigenvalues)), MarkerIndices=6)
    hold on;
    plot(linspace(1,20,20), diag(eigenvalues)/max(diag(eigenvalues)), 'ro', 'MarkerFaceColor', 'w');  % Pallini rossi sugli autovalori
    xlabel('Index');
    ylabel('Value %');
    grid on
    titolo=sprintf("eingenvalues k=%g", k);
    title(titolo)

    U=eigenvectors(:,1:num_connected_components(i));  %prendiamo un numero di colonne pari al numero di cluster(connected componentes), lasciando fissa la tolleranza

    % Apply k-means clustering
    [cluster_labels, cluster_centers] = kmeans(U,num_connected_components(i,1));
    

    subplot(2,2,3)
    spy(W)


    subplot(2,2,4)
    gscatter(X(:,1), X(:,2), cluster_labels, "rgb")
    titolo=sprintf("Dataset clustered with k=%g", k);
    title(titolo)


     i=i+1;
end

% other_cluster(X)

disp("Termine")
