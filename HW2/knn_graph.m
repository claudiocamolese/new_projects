function [W] = knn_graph(X,k)
% This function creates the k-nearest neighborhood similitarity graph and
% its adjacency matrix W
% X is the matrix whose graph need to be computed
% k are the number of neighborhoods
% sigma is the given parameter for the gaussian equation

    sigma=1;

    %initialize the matrix that after we will fill
    N = size(X, 1); %900x1
    W = zeros(N, N); %900x900
    
    % Trova i k vicini più prossimi per ogni punto
    for i = 1:N
        % Trova i k vicini più prossimi usando knnsearch.
        % "K" è per dirgli di trovare i k punti più vicini
        %we save for each close point, it's index and it's relative distance
        % this method includes the point itself so we can easily ignore it
        % after
        %knnsearch(X,Y,Name,Value) returns Idx with additional options specified using one or more 
        % name-value pair arguments. For example, you can specify the number of nearest neighbors to search for and the distance metric used in the search.
        [idx, dist] = knn_search(X, X(i, :),k); % +1 per includere il punto stesso
        % idx,dist = k x 1 
        % Imposta la matrice di similarità (usiamo l'equazione della Gaussiana)
        for j = 2:k % Ignora il punto stesso, perchè il primo valore di k è il punto stesso siccome è a distanza zero+
            % for each close point, the similiarity gaussian function is
            % computed
            W(i, idx(j)) = exp(-dist(j)^2 / (2 * sigma^2));
            W(idx(j), i) = W(i, idx(j)); % Grafo simmetrica
        end
    end
    if sum(diag(W)) ~= 0
        error("W has not all zero on the main diagonal")
        
    end
end

