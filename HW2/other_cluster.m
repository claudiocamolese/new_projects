function other_cluster(X)
    figure
    
    % DBSCAN Clustering
    subplot(2,2,1)
    db_cluster = dbscan(X, 0.8, 2, "Distance", "minkowski"); 
    gscatter(X(:,1), X(:,2), db_cluster)
    title('DBSCAN Clustering')
    
    % Gaussian Mixture Model (GMM)
    subplot(2,2,2)
    gm = fitgmdist(X, 3); % Fit a GMM with 3 components
    cluster_idx = cluster(gm, X);
    gscatter(X(:,1), X(:,2), cluster_idx)
    title('Gaussian Mixture Model Clustering')
    
    
    % K-means Clustering (new addition)
    subplot(2,2,3);
    k = 3; % Number of clusters
    idx_kmeans = kmeans(X, k); % K-means clustering
    gscatter(X(:,1), X(:,2), idx_kmeans);
    title('K-means Clustering');
    
    % Agglomerative Hierarchical Clustering (new addition)
    subplot(2,2,4);
    Z_agglom = linkage(X, 'average'); % Agglomerative clustering with average linkage
    cluster_idx_agglom = cluster(Z_agglom, 'maxclust', 3); % Define the number of clusters (e.g., 3)
    gscatter(X(:,1), X(:,2), cluster_idx_agglom);
    title('Agglomerative Hierarchical Clustering');
end
